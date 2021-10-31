import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    
    print(dbPath);
    final createdDb = sql.openDatabase(path.join(dbPath, 'progressions.db'),
        onCreate:  (db, version) => _createDb(db), version: 1);
    
    return createdDb;
  }

  static _createDb(sql.Database db) {
    db.execute('CREATE TABLE user_progressions(id TEXT PRIMARY KEY, name TEXT, interval INTEGER, chords TEXT)');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (1, "Am, F, C, G", 4, "Basic");');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (2, "A, C, Em, D", 5, "");');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (3, "G, D, Am, G, D, C", 5, "Knocking on heavens door");');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (4, "D, F#m, D, F#m, Bm, G, A, Bm, A", 3, "Hey there delilah");');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (5, "A, Ab, F#m, D, E, F#m, D, E, F#m, A", 6, "Someone like you");');
    db.execute('INSERT into user_progressions (id, chords, interval, name) VALUES (6, "C#m, Eb, G7, Bbm", 4, "");');
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
