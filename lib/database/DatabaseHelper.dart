import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(username TEXT PRIMARY KEY, counter INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<int> getCounter(String username) async {
    final db = await database;
    var result = await db.query('users', where: "username = ?", whereArgs: [username]);
    if (result.isNotEmpty) {
      return result.first['counter'] as int;
    } else {
      await db.insert('users', {'username': username, 'counter': 0});
      return 0;
    }
  }

  Future<void> updateCounter(String username, int counter) async {
    final db = await database;
    await db.update('users', {'counter': counter}, where: "username = ?", whereArgs: [username]);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
