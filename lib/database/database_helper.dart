import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance_system.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        password TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        matricule_number TEXT UNIQUE NOT NULL,
        date_of_birth DATETIME NOT NULL,
        department TEXT NOT NULL,
        facial_image TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE videos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        video_path TEXT NOT NULL
      );
    ''');
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    final db = await instance.database;
    return await db.insert('students', student);
  }

  Future<Map<String, dynamic>?> getTeacherByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'teachers',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertTeacher(Map<String, dynamic> teacher) async {
    final db = await instance.database;
    return await db.insert('teachers', teacher);
  }

  Future<int> saveVideo(String videoPath) async {
    final db = await database;
    return await db.insert(
      'videos',
      {'video_path': videoPath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
