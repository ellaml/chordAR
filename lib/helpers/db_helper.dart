import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    // await sql.deleteDatabase(dbPath);
    //final joinedPath = path.join(dbPath, 'progressions.db');
    //await sql.deleteDatabase(joinedPath);
    print(dbPath);
    final createdDb = sql.openDatabase(path.join(dbPath, 'progressions.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_progressions(id TEXT PRIMARY KEY, name TEXT, interval INTEGER, chords TEXT);' +
          'INSERT into user_progressions (id, chords, interval, name) VALUES (1, "Am, F, C, G", 4);' +
          'INSERT into user_progressions (id, chords, interval, name) VALUES (2, "Em, G, Am, C", 5);' +
          'INSERT into user_progressions (id, chords, interval, name) VALUES (3, "Am, F, C, G", 5);' +
          'INSERT into user_progressions (id, chords, interval, name) VALUES (4, "C, Am, F, Fm", 5);');
          
    }, version: 1);
    
    return createdDb;
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
