import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/leader_board_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leaderboard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        score INTEGER
      )
    ''');
  }

  Future<int> insertEntry(LeaderboardEntry entry) async {
    Database db = await instance.database;
    return await db.insert('leaderboard', entry.toMap());
  }

  Future<List<LeaderboardEntry>> getTopEntries({int limit = 10}) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => LeaderboardEntry.fromMap(maps[i]));
  }

  Future<void> deleteAllEntries() async {
    Database db = await instance.database;
    await db.delete('leaderboard');
  }
}