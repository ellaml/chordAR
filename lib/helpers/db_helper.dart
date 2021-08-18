import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'progressions.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_progressions(id TEXT PRIMARY KEY, name TEXT, interval INTEGER, chords TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> remove(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

}
