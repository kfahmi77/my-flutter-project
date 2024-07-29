import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'word_puzzle.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE highscores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            score INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertScore(int score) async {
    final db = await database;
    await db.insert(
      'highscores',
      {'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace, // Update if same ID
    );
  }

  Future<List<Map<String, dynamic>>> getHighscores() async {
    final db = await database;
    return await db.query(
      'highscores',
      orderBy: 'score DESC', // Sort by highest score
    );
  }
}