import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/alarm.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'alarm_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        time TEXT,
        period TEXT,
        days TEXT,
        isEnabled INTEGER
      )
    ''');
  }

  Future<int> insertAlarm(Alarm alarm) async {
    final db = await database;

    return await db.insert(
      'alarms',
      {
        'title': alarm.title,
        'time': alarm.time,
        'period': alarm.period,
        'days': alarm.days.isEmpty ? '' : alarm.days.join(','),
        'isEnabled': alarm.isEnabled ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Alarm>> getAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alarms');

    return List.generate(maps.length, (i) {
      return Alarm(
        id: maps[i]['id'] as int,
        title: maps[i]['title'] as String,
        time: maps[i]['time'] as String,
        period: maps[i]['period'] as String,
        days: (maps[i]['days'] as String).isEmpty
            ? []
            : (maps[i]['days'] as String).split(','),
        isEnabled: maps[i]['isEnabled'] == 1,
      );
    });
  }

  Future<void> updateAlarm(int id, Alarm alarm) async {
    final db = await database;
    await db.update(
      'alarms',
      {
        'title': alarm.title,
        'time': alarm.time,
        'period': alarm.period,
        'days': alarm.days.join(','),
        'isEnabled': alarm.isEnabled ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAlarm(int id) async {
    final db = await database;
    await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
