import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tadarok/constants/data.dart';

part 'sql_state.dart';

class SqlCubit extends Cubit<SqlState> {
  SqlCubit() : super(SqlInitial());

  static SqlCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<List<Map<String, dynamic>>> homeScreenData = [];

  Future<void> ensureDatabaseInitialized() async {
    await createDatabase();
  }

  Future<void> createDatabase() async {
    await openDatabase('tadarok.db', version: 1, onCreate: (database, version) {
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
    database.execute('''CREATE TABLE surah_names (
          id INTEGER PRIMARY KEY,
           surah TEXT,
           mistake_counter INTEGER
           )''');
    database.execute('''
          CREATE TABLE surah_mistakes (
           id INTEGER PRIMARY KEY,
            surah_id INTEGER NOT NULL,
            verse_number INTEGER,
            mistake_kind INTEGER,
            mistake TEXT,
            mistake_repetition INTEGER,
            FOREIGN KEY (surah_id) REFERENCES surah_names(id)
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
            await txn.insert(
                'surah_names', {'surah': surahName, 'mistake_counter': 0});
          }
        });
      } catch (error) {
        if (kDebugMode) {
          print('Error inserting Surah names: $error');
        }
      }
      if (kDebugMode) {
        print('surah inserted for the first time successfully');
      }
    } else {
      if (kDebugMode) {
        print('surah names already inserted');
      }
    }
  }

  // void _getDatabase(database) async {
  //   database.rawQuery('SELECT * FROM surah_names').then((value) {
  //     value.forEach((element) {
  //       if (kDebugMode) {
  //         print(element['surah']);
  //       }
  //     });
  //     // emit(AppGetDatabaseState());
  //   });
  // }

  insertToDatabase({
    required int surahId,
    required int verseNumber,
    required int mistakeKind,
    required String mistake,
    required int mistakeRepetition,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert('''
          INSERT INTO surah_mistakes(
          surah_id,
          verse_number, 
          mistake_kind, 
          mistake,
          mistake_repetition
          ) 
          VALUES (?, ?, ?, ?, ?)
          ''', [surahId, verseNumber, mistakeKind, mistake, mistakeRepetition]);
    }).then((value) async {
      if (kDebugMode) {
        print('$value inserted successfully');
      }

      await database.transaction((txn) {
        return txn.rawUpdate('''
      UPDATE surah_names
      SET mistake_counter = mistake_counter + 1
      WHERE id = ?
    ''', [surahId]);
      }).then((value) {
        if (kDebugMode) {
          print('$value updated successfully');
        }
        emit(InsertDatabaseState());
        getDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print('error when updating counter for new record $error');
        }
      });

      // database.rawQuery('SELECT * FROM surah_mistakes').then((value) {
      //   for (var element in value) {
      //     if (kDebugMode) {
      //       print(element);
      //     }
      //   }
      // });
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
      s.id AS surah_id, 
      s.surah, 
      s.mistake_counter,
      m.id AS mistake_id,
      m.verse_number,
      m.mistake_kind,
      m.mistake,
      m.mistake_repetition
    FROM surah_names s
    LEFT JOIN surah_mistakes m ON s.id = m.surah_id
    WHERE m.id IS NOT NULL
    ORDER BY s.id, m.verse_number, m.id
  ''');
    // Group the raw data by surah_id
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    for (final row in rawData) {
      final surahId = row['surah_id'] as int;
      if (!groupedData.containsKey(surahId)) {
        groupedData[surahId] = [];
      }
      groupedData[surahId]!.add(row);
    }

    // Create the homeScreenData list of lists

    homeScreenData = groupedData.entries.map((entry) {
      return entry.value;
    }).toList();

    // homeScreenData = groupedData.entries.map((entry) {
    //   return {
    //     'surah_id': entry.key,
    //     'surah': entry.value.first['surah'] as String,
    //     'mistake_counter': entry.value.first['mistake_counter'] as int,
    //     'mistakes': entry.value.map((mistake) {
    //       return {
    //         'mistake_id': mistake['mistake_id'] as int,
    //         'verse_number': mistake['verse_number'] as int,
    //         'mistake_kind': mistake['mistake_kind'] as int,
    //         'mistake': mistake['mistake'] as String,
    //         'mistake_repetition': mistake['mistake_repetition'] as int,
    //       };
    //     }).toList(),
    //   };
    // }).toList();
    emit(GetDatabaseState());
    displayDatabase();
  }

  Future<void> displayDatabase() async {
    // for (final row in homeScreenData) {
    //   if (kDebugMode) {
    //     print('Surah: ${row['surah']}');
    //     print('Surah ID: ${row['surah_id']}');
    //     print('Mistake Counter: ${row['mistake_counter']}');
    //     print('Mistake ID: ${row['mistake_id']}');
    //     print('Verse Number: ${row['verse_number']}');
    //     print('Mistake Kind: ${row['mistake_kind']}');
    //     print('Mistake: ${row['mistake']}');
    //     print('Mistake Repetition: ${row['mistake_repetition']}');
    //     print('---');
    //   }
    // }
    // print(homeScreenData);
    for (final surah in homeScreenData) {
      // if (kDebugMode) {
      //   print('Surah: ${surah['surah']}');
      //   print('Surah ID: ${surah['surah_id']}');
      //   print('Mistake Counter: ${surah['mistake_counter']}');
      // }
      print(surah.indexed);
      for (final mistake in surah) {
        if (kDebugMode) {
          print('Mistake ID: ${mistake['mistake_id']}');
          print('Verse Number: ${mistake['verse_number']}');
          print('Mistake Kind: ${mistake['mistake_kind']}');
          print('Mistake: ${mistake['mistake']}');
          print('Mistake Repetition: ${mistake['mistake_repetition']}');
          print('---');
        }
      }
    }
  }

  void deleteDatabase({
    required int mistakeId,
  }) {
    database
        .rawDelete('DELETE FROM surah_mistakes WHERE id = ?', [mistakeId]).then(
            (value) async {
      if (kDebugMode) {
        print('$value deleted successfully');
      }

      await database.transaction((txn) {
        return txn.rawUpdate('''
                  UPDATE surah_names
                  SET mistake_counter = mistake_counter - 1
                  HERE id = ?
                ''', [mistakeId]);
      }).then((value) {
        if (kDebugMode) {
          print('$value updated successfully');
        }
        emit(DeleteDatabaseState());
        getDatabase(database);
      }).catchError((error) {
        if (kDebugMode) {
          print('error when updating counter for deleted record $error');
        }
      });
    });
  }
}
