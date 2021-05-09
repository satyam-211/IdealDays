import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DayTasksDB {
  static var table;

  DayTasksDB._privateConstructor();
  static final DayTasksDB instance = DayTasksDB._privateConstructor();

  static Database _database;

  static set tableCreate(String tableName) {
    table = tableName;
    instance.database.then((db) => db.execute(
        'CREATE TABLE IF NOT EXISTS $table (id TEXT PRIMARY KEY, description TEXT , taskType INTEGER , time TEXT ,percentageCompleted REAL)'));
  }

  Future<Database> get database async {
    if (_database == null) {
      final dbPath = await sql.getDatabasesPath();
      _database =
          await sql.openDatabase(path.join(dbPath, 'tasks.db'), version: 1);
    }
    return _database;
  }

  Future<void> insertTask(Map<String, Object> data) async {
    final db = await instance.database;
    db.insert(
      table,
      data,
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await instance.database;
    return db.query(table);
  }

  Future<List<Map<String, dynamic>>> getTasksFromTable(String tableName) async {
    final db = await instance.database;
    return db.query(tableName);
  }

  void deleteTable(String tableName) async {
    final db = await instance.database;
    db.execute('DROP TABLE $tableName');
  }

  Future<int> deleteTask(String id) async {
    final db = await instance.database;
    var res = await db.delete(table, where: "id = ?", whereArgs: [id]);
    return res;
  }

  Future<int> update(String id, double percentageCompleted) async {
    final db = await instance.database;
    var res = await db.update(
        table, {"percentageCompleted": '$percentageCompleted'},
        where: "id = ?", whereArgs: [id]);
    return res;
  }
}
