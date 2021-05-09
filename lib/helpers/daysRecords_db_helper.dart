import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DaysRecordsDB {
  // the table name
  static final table = "my_table";
  // privateconstructor
  DaysRecordsDB._privateConstructor();
  static final DaysRecordsDB instance = DaysRecordsDB._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      final dbPath = await sql.getDatabasesPath();
      _database = await sql.openDatabase(path.join(dbPath, 'dayTasks.db'),
          onCreate: (db, version) async {
        return await db.execute(
            'CREATE TABLE $table (id TEXT PRIMARY KEY,tasks TEXT,percentageCompleted REAL);');
      }, version: 1);
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> getDayTasks() async {
    final db = await instance.database;
    return db.query(table);
  }

  Future<void> insertDayTask(Map<String, Object> data) async {
    final db = await instance.database;
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDayTask(String tasksDate) async {
    final db = await instance.database;
    await db.delete(table, where: "tasks = ?", whereArgs: [tasksDate]);
  }

  Future<int> update(String id, double percentageCompleted) async {
    final db = await instance.database;
    var res = await db.update(
        table, {"percentageCompleted": '$percentageCompleted'},
        where: "id = ?", whereArgs: [id]);
    return res;
  }
}
