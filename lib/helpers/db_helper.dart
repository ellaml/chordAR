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
          'CREATE TABLE user_progressions(id TEXT PRIMARY KEY, name TEXT, interval INTEGER, chords TEXT)');
    }, version: 1);
    insert('user_progressions',
        {'id': '1', 'chords': "Am, F, C, G", 'interval': 4, 'name': "Basic1"});
    insert('user_progressions',
        {'id': '2', 'chords': "Em, G, Am, C", 'interval': 5, 'name': "Basic2"});
    insert('user_progressions',
        {'id': '3', 'chords': "Am, F, C, G", 'interval': 5, 'name': "Basic3"});
    insert('user_progressions',
        {'id': '4', 'chords': "C, Am, F, Fm", 'interval': 5, 'name': "Basic4"});
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
