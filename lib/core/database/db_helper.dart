import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mediapp.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        token TEXT
      )
    ''');
  }

  // Guardar usuario
  Future<void> insertUser(String email, String token) async {
    final db = await database;
    await db.insert(
      'users',
      {'email': email, 'token': token},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener usuario
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) return res.first;
    return null;
  }

  // Borrar usuario
  Future<void> deleteUser(String email) async {
    final db = await database;
    await db.delete('users', where: 'email = ?', whereArgs: [email]);
  }
}
