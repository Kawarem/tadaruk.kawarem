import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sqflite/sqflite.dart';
import 'package:tadarok/constants/data.dart';
import 'package:tadarok/helpers/app_cash_helper.dart';
import 'package:tadarok/helpers/local_notifications_helper.dart';
import 'package:tadarok/state_management/app_bloc/app_bloc.dart';

part 'sql_state.dart';

class SqlCubit extends Cubit<SqlState> {
  SqlCubit() : super(SqlInitial());

  static SqlCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<List<Map<String, dynamic>>> homeScreenSurahData = [];
  List<List<Map<String, dynamic>>> homeScreenPageNumberData = [];
  List<List<Map<String, dynamic>>> homeScreenJuzNumberData = [];
  List<List<Map<String, dynamic>>> homeScreenMistakeRepetitionSurahData = [];
  static Map<int, Map<String, dynamic>> idData = {};
  static List<int> notificationsIdsList = [];
  static int counter = 0;

  Future<void> ensureDatabaseInitialized() async {
    await createDatabase();
  }

  Future<void> createDatabase() async {
    await openDatabase('kawarem.tadarok.db', version: 1,
        onCreate: (database, version) {
      _onCreate(database);
      if (kDebugMode) {
        print('database created');
      }
    }, onOpen: (database) {
      ensureSurahNamesInitialized(database);
      getDatabase(database);
      if (kDebugMode) {
        print('database opened');
      }
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  static void _onCreate(Database database) {
    database.execute('''
        CREATE TABLE surah_names (
          id INTEGER PRIMARY KEY,
          surah TEXT
        )
           ''');
    database.execute('''
          CREATE TABLE surah_mistakes (
            id INTEGER PRIMARY KEY,
            surah_number INTEGER NOT NULL,
            verse_number INTEGER,
            page_number INTEGER,
            juz_number INTEGER,
            mistake_kind INTEGER,
            mistake TEXT,
            note TEXT,
            mistake_repetition INTEGER,
            FOREIGN KEY (surah_number) REFERENCES surah_names(id)
          )''');
  }

  Future<void> ensureSurahNamesInitialized(database) async {
    final count = Sqflite.firstIntValue(
      await database.rawQuery('SELECT COUNT(*) FROM surah_names'),
    );
    if (count == 0) {
      try {
        await database.transaction((txn) async {
          for (final surahName in quranSurahNames) {
            await txn.insert('surah_names', {'surah': surahName});
          }
        });
      } catch (error) {
        if (kDebugMode) {
          print('Error inserting Surah names: $error');
        }
      }
      if (kDebugMode) {
        print('surahs inserted for the first time successfully');
      }
    } else {
      if (kDebugMode) {
        print('surah names already inserted');
      }
    }
  }

  insertToDatabase({
    required int surahNumber,
    required int verseNumber,
    required int mistakeKind,
    required String mistake,
    required String note,
    required int mistakeRepetition,
  }) async {
    int pageNumber = quran.getPageNumber(surahNumber, verseNumber);
    int juzNumber = quran.getJuzNumber(surahNumber, verseNumber);
    await database.transaction((txn) {
      return txn.rawInsert('''
          INSERT INTO surah_mistakes(
          surah_number,
          verse_number, 
          page_number, 
          juz_number, 
          mistake_kind, 
          mistake,
          note,
          mistake_repetition
          ) 
          VALUES (?, ?, ?, ?, ?, ?, ?, ?)
          ''', [
        surahNumber,
        verseNumber,
        pageNumber,
        juzNumber,
        mistakeKind,
        mistake,
        note,
        mistakeRepetition
      ]);
    }).then((value) async {
      if (kDebugMode) {
        print('$value inserted successfully');
      }
      emit(InsertDatabaseState());
      await getDatabase(database);
    }).catchError((error) {
      if (kDebugMode) {
        print('error when inserting new record $error');
      }
    });
  }

  Future<void> getDatabase(Database database) async {
    dynamic db = database;
    List<Map<String, dynamic>> rawData = await db.rawQuery('''
    SELECT 
      s.id AS surah_number, 
      s.surah, 
      m.id AS mistake_id,
      m.verse_number,
      m.page_number,
      m.juz_number,
      m.mistake_kind,
      m.mistake,
      m.note,
      m.mistake_repetition
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL
    ORDER BY s.id, m.verse_number, m.id
  ''');
    // Group the raw data by surah_number
    Map<int, List<Map<String, dynamic>>> surahGroupedData = {};
    for (final row in rawData) {
      final surahNumber = row['surah_number'] as int;
      if (!surahGroupedData.containsKey(surahNumber)) {
        surahGroupedData[surahNumber] = [];
      }
      surahGroupedData[surahNumber]!.add(row);
    }
    // Group the raw data by page_number
    Map<int, List<Map<String, dynamic>>> pageGroupedData = {};
    for (final row in rawData) {
      final pageNumber = row['page_number'] as int;
      if (!pageGroupedData.containsKey(pageNumber)) {
        pageGroupedData[pageNumber] = [];
      }
      pageGroupedData[pageNumber]!.add(row);
    }
    // Group the raw data by juz_number
    Map<int, List<Map<String, dynamic>>> juzGroupedData = {};
    for (final row in rawData) {
      final juzNumber = row['juz_number'] as int;
      if (!juzGroupedData.containsKey(juzNumber)) {
        juzGroupedData[juzNumber] = [];
      }
      juzGroupedData[juzNumber]!.add(row);
    }
    // Group the raw data by mistake_id
    notificationsIdsList.clear();
    Map<int, Map<String, dynamic>> idGroupedData = {};
    for (final row in rawData) {
      final id = row['mistake_id'] as int;
      idGroupedData[id] = row;
      for (int i = 0; i < row['mistake_repetition']; i++) {
        notificationsIdsList.add(row['mistake_id']);
        counter++;
      }
      if (kDebugMode) {
        print(notificationsIdsList);
      }
    }
    // Reorder data according to mistake_repetition
    rawData = await db.rawQuery('''
    SELECT 
      s.id AS surah_number, 
      s.surah, 
      m.id AS mistake_id,
      m.verse_number,
      m.page_number,
      m.juz_number,
      m.mistake_kind,
      m.mistake,
      m.note,
      m.mistake_repetition
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL
    ORDER BY m.mistake_repetition DESC, s.id, m.verse_number, m.id
  ''');
    // Group the raw data by mistake_repetition
    Map<int, List<Map<String, dynamic>>> mistakeRepetitionGroupedData = {};
    for (final row in rawData) {
      final mistakeRepetition = row['mistake_repetition'] as int;
      if (!mistakeRepetitionGroupedData.containsKey(mistakeRepetition)) {
        mistakeRepetitionGroupedData[mistakeRepetition] = [];
      }
      mistakeRepetitionGroupedData[mistakeRepetition]!.add(row);
    }

    // Create the homeScreenData list of lists
    homeScreenSurahData = surahGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    homeScreenPageNumberData = pageGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    homeScreenJuzNumberData = juzGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    homeScreenMistakeRepetitionSurahData =
        mistakeRepetitionGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    idData = idGroupedData;
    AppBloc.notificationsIdsList = notificationsIdsList;
    await AppCacheHelper().cacheIdsList(notificationsIdsList);
    emit(GetDatabaseState());
    displayDatabase();
  }

  Future<void> displayDatabase() async {
    // for (final row in homeScreenData) {
    //   if (kDebugMode) {
    //     print('Surah: ${row['surah']}');
    //     print('Surah ID: ${row['surah_number']}');
    //     print('Mistake Counter: ${row['mistake_counter']}');
    //     print('Mistake ID: ${row['mistake_id']}');
    //     print('Verse Number: ${row['verse_number']}');
    //     print('Mistake Kind: ${row['mistake_kind']}');
    //     print('Mistake: ${row['mistake']}');
    //     print('note: ${row['note']}');
    //     print('Mistake Repetition: ${row['mistake_repetition']}');
    //     print('---');
    //   }
    // }
    // print(homeScreenData);
    for (final surah in homeScreenSurahData) {
      // if (kDebugMode) {
      //   print('Surah: ${surah['surah']}');
      //   print('Surah ID: ${surah['surah_number']}');
      //   print('Mistake Counter: ${surah['mistake_counter']}');
      // }
      if (kDebugMode) {
        print(surah.indexed);
      }
      for (final mistake in surah) {
        if (kDebugMode) {
          print('ID: ${mistake['mistake_id']}');
          print('Verse Number: ${mistake['verse_number']}');
          print('Page Number: ${mistake['page_number']}');
          print('Juz Number: ${mistake['juz_number']}');
          print('Mistake Kind: ${mistake['mistake_kind']}');
          print('Mistake: ${mistake['mistake']}');
          print('Note: ${mistake['note']}');
          print('Mistake Repetition: ${mistake['mistake_repetition']}');
          print('---');
        }
      }
    }
  }

  void updateDatabase({
    required int id,
    required int surahNumber,
    required int verseNumber,
    required int mistakeKind,
    required String mistake,
    required String note,
    required int mistakeRepetition,
  }) {
    int pageNumber = quran.getPageNumber(surahNumber, verseNumber);
    int juzNumber = quran.getJuzNumber(surahNumber, verseNumber);
    database.rawUpdate('''
    UPDATE surah_mistakes
    SET
      surah_number = ?,
      verse_number = ?, 
      page_number = ?, 
      juz_number = ?, 
      mistake_kind = ?, 
      mistake = ?,
      note = ?,
      mistake_repetition = ?
    WHERE id = ?
    ''', [
      surahNumber,
      verseNumber,
      pageNumber,
      juzNumber,
      mistakeKind,
      mistake,
      note,
      mistakeRepetition,
      id
    ]).then((value) async {
      emit(UpdateDatabaseState());
      await getDatabase(database);
      if (AppBloc.isNotificationsActivated) {
        LocalNotificationsHelper.scheduleRecurringNotifications();
      }
      debugPrint('database updated: $value');
    });
  }

  void deleteFromDatabase({
    required int id,
  }) {
    database.rawDelete('DELETE FROM surah_mistakes WHERE id = ?', [id]).then(
        (value) async {
      if (kDebugMode) {
        print('$value deleted successfully');
      }
      emit(DeleteDatabaseState());
      getDatabase(database);
    });
  }
}
