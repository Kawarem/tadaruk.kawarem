import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sqflite/sqflite.dart';
import 'package:tadaruk/constants/colors.dart';
import 'package:tadaruk/constants/components.dart';
import 'package:tadaruk/constants/data.dart';
import 'package:tadaruk/helpers/local_notifications_helper.dart';
import 'package:tadaruk/state_management/app_bloc/app_bloc.dart';
import 'package:vibration/vibration.dart';

part 'sql_state.dart';

class SqlCubit extends Cubit<SqlState> {
  SqlCubit() : super(SqlInitial());

  static SqlCubit get(context) => BlocProvider.of(context);

  late Database database;
  static List<List<Map<String, dynamic>>> homeScreenSurahData = [];
  static List<List<Map<String, dynamic>>> homeScreenPageNumberData = [];
  static List<List<Map<String, dynamic>>> homeScreenJuzNumberData = [];
  static List<List<Map<String, dynamic>>> homeScreenMistakeKindSurahData = [];
  static List<List<Map<String, dynamic>>> homeScreenMistakeRepetitionSurahData =
      [];
  static List<List<Map<String, dynamic>>> archivedScreenSurahData = [];
  static List<List<Map<String, dynamic>>> archivedScreenPageNumberData = [];
  static List<List<Map<String, dynamic>>> archivedScreenJuzNumberData = [];
  static List<List<Map<String, dynamic>>> archivedScreenMistakeKindSurahData =
      [];
  static List<List<Map<String, dynamic>>>
      archivedScreenMistakeRepetitionSurahData = [];
  static Map<int, Map<String, dynamic>> idData = {};
  static List<int> notificationsIds = [];
  static int counter = 0;

  Future<void> ensureDatabaseInitialized() async {
    await createDatabase();
  }

  Future<void> createDatabase() async {
    await openDatabase('kawarem.tadaruk.db', version: 2,
        onCreate: (database, version) {
      _onCreate(database);
      if (kDebugMode) {
        print('database created');
      }
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            'ALTER TABLE surah_mistakes ADD COLUMN archived INTEGER DEFAULT 0');
        debugPrint('Database updated to version 2');
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
            FOREIGN KEY (surah_number) REFERENCES surah_names(id),
            archived INTEGER DEFAULT 0
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
        mistakeRepetition,
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
      m.mistake_repetition,
      m.archived
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL AND m.archived = 0
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
    notificationsIds.clear();
    counter = 0;
    Map<int, List<Map<String, dynamic>>> juzGroupedData = {};
    for (final row in rawData) {
      final juzNumber = row['juz_number'] as int;
      if (!juzGroupedData.containsKey(juzNumber)) {
        juzGroupedData[juzNumber] = [];
      }
      juzGroupedData[juzNumber]!.add(row);
      // prepare notifications' ids
      for (int i = 0; i < row['mistake_repetition']; i++) {
        //
        notificationsIds.add(row['mistake_id']);
        counter++;
      }
      if (kDebugMode) {
        print(notificationsIds);
      }
    }
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
      m.mistake_repetition,
      m.archived
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL
    ORDER BY s.id, m.verse_number, m.id
  ''');
    // Group the raw data by mistake_id
    // notificationsIds.clear();
    Map<int, Map<String, dynamic>> idGroupedData = {};
    for (final row in rawData) {
      final id = row['mistake_id'] as int;
      idGroupedData[id] = row;
      // for (int i = 0; i < row['mistake_repetition']; i++) {
      //   notificationsIds.add(row['mistake_id']);
      //   counter++;
      // }
      // if (kDebugMode) {
      //   print(notificationsIds);
      // }
    }
    // Reorder data according to mistake_kind
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
        m.mistake_repetition,
        m.archived
      FROM surah_names s
      LEFT JOIN surah_mistakes m ON s.id = m.surah_number
      WHERE m.id IS NOT NULL AND m.archived = 0
      ORDER BY m.mistake_kind, s.id, m.verse_number, m.id
    ''');
    // Group the raw data by mistake_kind
    Map<int, List<Map<String, dynamic>>> mistakeKindGroupedData = {};
    for (final row in rawData) {
      final mistakeRepetition = row['mistake_kind'] as int;
      if (!mistakeKindGroupedData.containsKey(mistakeRepetition)) {
        mistakeKindGroupedData[mistakeRepetition] = [];
      }
      mistakeKindGroupedData[mistakeRepetition]!.add(row);
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
      m.mistake_repetition,
      m.archived
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL AND m.archived = 0
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
    homeScreenMistakeKindSurahData =
        mistakeKindGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    homeScreenMistakeRepetitionSurahData =
        mistakeRepetitionGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    idData = idGroupedData;

    // archived data
    List<Map<String, dynamic>> archivedRawData = await db.rawQuery('''
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
      m.mistake_repetition,
      m.archived
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL AND m.archived = 1
    ORDER BY s.id, m.verse_number, m.id
  ''');
    // Group the raw data by surah_number
    Map<int, List<Map<String, dynamic>>> archivedSurahGroupedData = {};
    for (final row in archivedRawData) {
      final surahNumber = row['surah_number'] as int;
      if (!archivedSurahGroupedData.containsKey(surahNumber)) {
        archivedSurahGroupedData[surahNumber] = [];
      }
      archivedSurahGroupedData[surahNumber]!.add(row);
    }
    // Group the raw data by page_number
    Map<int, List<Map<String, dynamic>>> archivedPageGroupedData = {};
    for (final row in archivedRawData) {
      final pageNumber = row['page_number'] as int;
      if (!archivedPageGroupedData.containsKey(pageNumber)) {
        archivedPageGroupedData[pageNumber] = [];
      }
      archivedPageGroupedData[pageNumber]!.add(row);
    }
    // Group the raw data by juz_number
    Map<int, List<Map<String, dynamic>>> archivedJuzGroupedData = {};
    for (final row in archivedRawData) {
      final juzNumber = row['juz_number'] as int;
      if (!archivedJuzGroupedData.containsKey(juzNumber)) {
        archivedJuzGroupedData[juzNumber] = [];
      }
      archivedJuzGroupedData[juzNumber]!.add(row);
    }
    // // Group the raw data by mistake_id
    // notificationsIdsList.clear();
    // Map<int, Map<String, dynamic>> idGroupedData = {};
    // for (final row in archivedRawData) {
    //   final id = row['mistake_id'] as int;
    //   idGroupedData[id] = row;
    //   for (int i = 0; i < row['mistake_repetition']; i++) {
    //     notificationsIdsList.add(row['mistake_id']);
    //     counter++;
    //   }
    //   if (kDebugMode) {
    //     print(notificationsIdsList);
    //   }
    // }
    // Reorder archived data according to mistake_kind
    archivedRawData = await db.rawQuery('''
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
        m.mistake_repetition,
        m.archived
      FROM surah_names s
      LEFT JOIN surah_mistakes m ON s.id = m.surah_number
      WHERE m.id IS NOT NULL AND m.archived = 1
      ORDER BY m.mistake_kind, s.id, m.verse_number, m.id
    ''');
    // Group the raw data by mistake_kind
    Map<int, List<Map<String, dynamic>>> archivedMistakeKindGroupedData = {};
    for (final row in archivedRawData) {
      final mistakeRepetition = row['mistake_kind'] as int;
      if (!archivedMistakeKindGroupedData.containsKey(mistakeRepetition)) {
        archivedMistakeKindGroupedData[mistakeRepetition] = [];
      }
      archivedMistakeKindGroupedData[mistakeRepetition]!.add(row);
    }
    // Reorder data according to mistake_repetition
    archivedRawData = await db.rawQuery('''
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
      m.mistake_repetition,
      m.archived
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_number
    WHERE m.id IS NOT NULL AND m.archived = 1
    ORDER BY m.mistake_repetition DESC, s.id, m.verse_number, m.id
  ''');
    // Group the raw data by mistake_repetition
    Map<int, List<Map<String, dynamic>>> archivedMistakeRepetitionGroupedData =
        {};
    for (final row in archivedRawData) {
      final mistakeRepetition = row['mistake_repetition'] as int;
      if (!archivedMistakeRepetitionGroupedData
          .containsKey(mistakeRepetition)) {
        archivedMistakeRepetitionGroupedData[mistakeRepetition] = [];
      }
      archivedMistakeRepetitionGroupedData[mistakeRepetition]!.add(row);
    }

    // Create the archivedScreenData list of lists
    archivedScreenSurahData = archivedSurahGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    archivedScreenPageNumberData = archivedPageGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    archivedScreenJuzNumberData = archivedJuzGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    archivedScreenMistakeKindSurahData =
        archivedMistakeKindGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();
    archivedScreenMistakeRepetitionSurahData =
        archivedMistakeRepetitionGroupedData.entries.map((entry) {
      return entry.value;
    }).toList();

    emit(GetDatabaseState());
    printDatabase();
    changerCategoryType();
    if (AppBloc.isNotificationsActivated) {
      await LocalNotificationsHelper.scheduleRecurringNotifications();
    }
    FlutterNativeSplash.remove();
  }

  static void changerCategoryType() {
    switch (AppBloc.displayTypeInHomeScreen) {
      case 0:
        AppBloc.displayDataInHomeScreen = homeScreenSurahData;
        AppBloc.displayDataInArchivedMistakesScreen = archivedScreenSurahData;
      case 1:
        AppBloc.displayDataInHomeScreen = homeScreenPageNumberData;
        AppBloc.displayDataInArchivedMistakesScreen =
            archivedScreenPageNumberData;
      case 2:
        AppBloc.displayDataInHomeScreen = homeScreenJuzNumberData;
        AppBloc.displayDataInArchivedMistakesScreen =
            archivedScreenJuzNumberData;
      case 3:
        AppBloc.displayDataInHomeScreen = homeScreenMistakeKindSurahData;
        AppBloc.displayDataInArchivedMistakesScreen =
            archivedScreenMistakeKindSurahData;
      case 4:
        AppBloc.displayDataInHomeScreen = homeScreenMistakeRepetitionSurahData;
        AppBloc.displayDataInArchivedMistakesScreen =
            archivedScreenMistakeRepetitionSurahData;
      default:
        AppBloc.displayDataInHomeScreen = homeScreenSurahData;
        AppBloc.displayDataInArchivedMistakesScreen = archivedScreenSurahData;
    }
  }

  Future<void> printDatabase() async {
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
          print('Archived: ${mistake['archived']}');
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
  }) async {
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
      debugPrint('database updated: $value');
      await LocalNotificationsHelper.cancelAll();
      await getDatabase(database);
    });
  }

  void deleteFromDatabase(
    context, {
    required int id,
  }) async {
    database.rawDelete('DELETE FROM surah_mistakes WHERE id = ?', [id]).then(
        (value) async {
      if (kDebugMode) {
        print('$value deleted successfully');
      }
      emit(DeleteDatabaseState());
      await LocalNotificationsHelper.cancelAll();
      await getDatabase(database);
      validateNotificationsActivation(context);
    });
  }

  Future<void> deleteAllMistakesFor(context,
      {required int index, required bool isArchived}) async {
    int archived = (isArchived) ? 1 : 0;
    switch (AppBloc.displayTypeInHomeScreen) {
      case 0:
        database.rawDelete(
            'DELETE FROM surah_mistakes WHERE surah_number = ? AND archived = $archived',
            [index]).then((value) async {
          if (kDebugMode) {
            print(
                '$value archived mistakes from surah $index were deleted successfully');
          }
          emit(DeleteDatabaseState());
          await getDatabase(database);
        });
      case 1:
        database.rawDelete(
            'DELETE FROM surah_mistakes WHERE page_number = ? AND archived = $archived',
            [index]).then((value) async {
          if (kDebugMode) {
            print(
                '$value archived mistakes from page $index were deleted successfully');
          }
          emit(DeleteDatabaseState());
          await getDatabase(database);
        });
      case 2:
        database.rawDelete(
            'DELETE FROM surah_mistakes WHERE juz_number = ? AND archived = $archived',
            [index]).then((value) async {
          if (kDebugMode) {
            print(
                '$value archived mistakes from juz $index were deleted successfully');
          }
          emit(DeleteDatabaseState());
          await getDatabase(database);
        });
      case 3:
        database.rawDelete(
            'DELETE FROM surah_mistakes WHERE mistake_kind = ? AND archived = $archived',
            [index]).then((value) async {
          if (kDebugMode) {
            print(
                '$value archived mistakes from mistake_kind $index were deleted successfully');
          }
          emit(DeleteDatabaseState());
          await getDatabase(database);
        });
      case 4:
        database.rawDelete(
            'DELETE FROM surah_mistakes WHERE mistake_repetition = ? AND archived = $archived',
            [index]).then((value) async {
          if (kDebugMode) {
            print(
                '$value archived mistakes from mistake_repetition $index were deleted successfully');
          }
          emit(DeleteDatabaseState());
          await getDatabase(database);
        });
    }
  }

  // Future<void> deleteAllArchivedMistakesFor(context,
  //     {required int index}) async {
  //   switch (AppBloc.displayTypeInHomeScreen) {
  //     case 0:
  //       database.rawDelete(
  //           'DELETE FROM surah_mistakes WHERE surah_number = ? AND archived = 1',
  //           [index]).then((value) async {
  //         if (kDebugMode) {
  //           print(
  //               '$value archived mistakes from surah $index were deleted successfully');
  //         }
  //         emit(DeleteDatabaseState());
  //         await getDatabase(database);
  //       });
  //     case 1:
  //       database.rawDelete(
  //           'DELETE FROM surah_mistakes WHERE page_number = ? AND archived = 1',
  //           [index]).then((value) async {
  //         if (kDebugMode) {
  //           print(
  //               '$value archived mistakes from page $index were deleted successfully');
  //         }
  //         emit(DeleteDatabaseState());
  //         await getDatabase(database);
  //       });
  //     case 2:
  //       database.rawDelete(
  //           'DELETE FROM surah_mistakes WHERE juz_number = ? AND archived = 1',
  //           [index]).then((value) async {
  //         if (kDebugMode) {
  //           print(
  //               '$value archived mistakes from juz $index were deleted successfully');
  //         }
  //         emit(DeleteDatabaseState());
  //         await getDatabase(database);
  //       });
  //     case 3:
  //       database.rawDelete(
  //           'DELETE FROM surah_mistakes WHERE mistake_kind = ? AND archived = 1',
  //           [index]).then((value) async {
  //         if (kDebugMode) {
  //           print(
  //               '$value archived mistakes from mistake_kind $index were deleted successfully');
  //         }
  //         emit(DeleteDatabaseState());
  //         await getDatabase(database);
  //       });
  //     case 4:
  //       database.rawDelete(
  //           'DELETE FROM surah_mistakes WHERE mistake_repetition = ? AND archived = 1',
  //           [index]).then((value) async {
  //         if (kDebugMode) {
  //           print(
  //               '$value archived mistakes from mistake_repetition $index were deleted successfully');
  //         }
  //         emit(DeleteDatabaseState());
  //         await getDatabase(database);
  //       });
  //   }
  // }

  String? databasePath;
  Directory? externalStoragePath;

  _getDatabasePath() async {
    databasePath = await getDatabasesPath();
    debugPrint('database path: $databasePath');
    externalStoragePath = await getExternalStorageDirectory();
    debugPrint('external storage path: $externalStoragePath');
  }

  backupDatabase() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      try {
        final String databasePath = await getDatabasesPath();
        File ourDBFile = File('$databasePath/kawarem.tadaruk.db');
        Directory? folderPathForDBFile =
            Directory('/storage/emulated/0/Tadaruk Backups/');
        await folderPathForDBFile.create();

        final formattedDateTime =
            DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
        await ourDBFile.copy(
            '/storage/emulated/0/Tadaruk Backups/Tadaruk_backup_$formattedDateTime.db');
        Get.back();
        Get.back();
        debugPrint('Database backup successfully :)');
        Fluttertoast.showToast(
            msg:
                'تم إنشاء نسخة احتياطية بنجاح\n يمكنك إيجادها في ملفاتك ضمن مجلد اسمه Tadaruk backups',
            backgroundColor: TOAST_BACKGROUND_COLOR,
            toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        debugPrint('------------------------');
        debugPrint('Database backup failed :( ${e.toString()}');
        debugPrint('------------------------');
        Vibration.vibrate(duration: 50);
        Fluttertoast.showToast(
            msg: 'فشلت عملبة النسخ الاحتياطي',
            backgroundColor: TOAST_BACKGROUND_COLOR);
      }
    } else {
      debugPrint('Permission not granted');
      Vibration.vibrate(duration: 50);
      Fluttertoast.showToast(
          msg: 'فشلت عملية النسخ الاحتياطي: لا يوجد إذن بالوصول',
          backgroundColor: TOAST_BACKGROUND_COLOR);
    }
  }

  void restoreDatabase() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      try {
        // choose file
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          initialDirectory: '/storage/emulated/0/Tadaruk Backups/',
        );

        // check if user chose a file
        if (result != null) {
          // Get the selected backup file
          File selectedBackupFile = File(result.files.single.path!);

          // Check if the selected file is the correct database file
          String? fileExtension = result.files.single.extension;
          if (fileExtension == 'db') {
            final newDatabase = await openDatabase(result.files.single.path!);
            final isDatabaseMine = await newDatabase.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='surah_names'",
            );
            if (isDatabaseMine.isNotEmpty) {
              final String databasePath = await getDatabasesPath();
              await selectedBackupFile.copy('$databasePath/kawarem.tadaruk.db');
              await LocalNotificationsHelper.cancelAll();
              // List<Map<String, dynamic>> result =
              //     await database.rawQuery('PRAGMA user_version;');
              // int oldVersion = result.first['user_version'] as int;
              // print('old version: $oldVersion');
              database.close();
              await createDatabase();
              Get.back();
              Get.back();
              debugPrint('Database restored successfully :)');
              Fluttertoast.showToast(
                  msg: 'تم استعادة النسخة الاحتياطية بنجاح',
                  backgroundColor: TOAST_BACKGROUND_COLOR);
            } else {
              debugPrint('Selected file is not my db file');
              Vibration.vibrate(duration: 50);
              Fluttertoast.showToast(
                  msg:
                      'فشلت عملية استعادة النسخة الاحتياطية: الملف المختار غير مدعوم',
                  backgroundColor: TOAST_BACKGROUND_COLOR);
            }
          } else {
            debugPrint('Selected file is not a .db file');
            Vibration.vibrate(duration: 50);
            Fluttertoast.showToast(
                msg:
                    'فشلت عملية استعادة النسخة الاحتياطية: الملف المختار غير مدعوم',
                backgroundColor: TOAST_BACKGROUND_COLOR);
          }
        } else {
          debugPrint('No file selected');
          Vibration.vibrate(duration: 50);
          Fluttertoast.showToast(
              msg: 'فشلت عملية استعادة النسخة الاحتياطية: لم يتم اختيار ملف',
              backgroundColor: TOAST_BACKGROUND_COLOR);
        }
      } catch (e) {
        debugPrint('Database restore failed :( ${e.toString()}');
        Vibration.vibrate(duration: 50);
        Fluttertoast.showToast(
            msg: 'فشلت عملية استعادة النسخة الاحتياطية',
            backgroundColor: TOAST_BACKGROUND_COLOR);
      }
    } else {
      debugPrint('Permission not granted');
      Vibration.vibrate(duration: 50);
      Fluttertoast.showToast(
          msg: 'فشلت عملية استعادة النسخة الاحتياطية: لا يوجد إذن بالوصول',
          backgroundColor: TOAST_BACKGROUND_COLOR);
    }
  }

  void archiveAndUnarchiveMistake(
    context, {
    required int id,
    required isArchived,
  }) {
    int archived = (isArchived) ? 0 : 1;
    database.rawUpdate('''
    UPDATE surah_mistakes
    SET
      archived = ?
      WHERE id = ?
    ''', [archived, id]).then((value) async {
      emit(UpdateDatabaseState());
      debugPrint('database updated: $value');
      await LocalNotificationsHelper.cancelAll();
      await getDatabase(database);
      validateNotificationsActivation(context);
    });
  }

  Future<void> archiveAndUnarchiveAllMistakesFor(context,
      {required int index, required bool isArchived}) async {
    int archived = (isArchived) ? 0 : 1;
    switch (AppBloc.displayTypeInHomeScreen) {
      case 0:
        database.rawUpdate('''
                     UPDATE surah_mistakes
                     SET
                     archived = ?
                     WHERE surah_number = ?
    ''', [archived, index]).then((value) async {
          emit(UpdateDatabaseState());
          debugPrint('database updated: $value');
          await LocalNotificationsHelper.cancelAll();
          await getDatabase(database);
          validateNotificationsActivation(context);
        });
      case 1:
        database.rawUpdate('''
                     UPDATE surah_mistakes
                     SET
                     archived = ?
                     WHERE page_number = ?
    ''', [archived, index]).then((value) async {
          emit(UpdateDatabaseState());
          debugPrint('database updated: $value');
          await LocalNotificationsHelper.cancelAll();
          await getDatabase(database);
          validateNotificationsActivation(context);
        });
      case 2:
        database.rawUpdate('''
                     UPDATE surah_mistakes
                     SET
                     archived = ?
                     WHERE juz_number = ?
    ''', [archived, index]).then((value) async {
          emit(UpdateDatabaseState());
          debugPrint('database updated: $value');
          await LocalNotificationsHelper.cancelAll();
          await getDatabase(database);
          validateNotificationsActivation(context);
        });
      case 3:
        database.rawUpdate('''
                     UPDATE surah_mistakes
                     SET
                     archived = ?
                     WHERE mistake_kind = ?
    ''', [archived, index]).then((value) async {
          emit(UpdateDatabaseState());
          debugPrint('database updated: $value');
          await LocalNotificationsHelper.cancelAll();
          await getDatabase(database);
          validateNotificationsActivation(context);
        });
      case 4:
        database.rawUpdate('''
                     UPDATE surah_mistakes
                     SET
                     archived = ?
                     WHERE mistake_repetition = ?
    ''', [archived, index]).then((value) async {
          emit(UpdateDatabaseState());
          debugPrint('database updated: $value');
          await LocalNotificationsHelper.cancelAll();
          await getDatabase(database);
          validateNotificationsActivation(context);
        });
    }
  }
}
