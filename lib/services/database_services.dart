// services/database_services.dart
import 'dart:io';
import 'dart:async';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/models/launcher_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static String? _customDbPath;

  // Factory constructor for custom path
  factory DatabaseService.fromPath(String path) {
    final instance = DatabaseService();
    _customDbPath = path;
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> get _dbPath async {
    if (_customDbPath != null) {
      return _customDbPath!;
    }
    final documentsDir = await getApplicationDocumentsDirectory();
    final appDir = Directory(join(documentsDir.path, 'CafeLauncher'));
    if (!await appDir.exists()) {
      await appDir.create(recursive: true);
    }
    return join(appDir.path, 'CafeLauncher.db');
  }

  Future<Database> _initDatabase() async {
    final path = await _dbPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE LauncherConfig (
        Id INTEGER PRIMARY KEY CHECK (Id = 1),
        BackgroundColor TEXT NOT NULL DEFAULT '#1E1E2E',
        SidebarColor TEXT NOT NULL DEFAULT '#181825',
        AccentColor TEXT NOT NULL DEFAULT '#89B4FA',
        UseCoverArtView INTEGER NOT NULL DEFAULT 0,
        WallpaperPath TEXT,
        LastModified DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE Apps (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT NOT NULL UNIQUE,
        Category TEXT NOT NULL,
        ExecutionPath TEXT NOT NULL,
        IconPath TEXT NOT NULL DEFAULT '/Assets/placeholder.png',
        CoverArtPath TEXT NOT NULL DEFAULT '/Assets/placeholder.png',
        LastModified DATETIME DEFAULT CURRENT_TIMESTAMP,
        CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('CREATE INDEX idx_apps_category ON Apps(Category)');

    await db.execute('''
      CREATE TABLE RunningProcesses (
        ProcessId INTEGER PRIMARY KEY,
        AppId INTEGER NOT NULL,
        Category TEXT NOT NULL,
        StartedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (AppId) REFERENCES Apps(Id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_running_category ON RunningProcesses(Category)',
    );

    await db.rawInsert('INSERT OR IGNORE INTO LauncherConfig (Id) VALUES (1)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE LauncherConfig ADD COLUMN WallpaperPath TEXT',
        );
      } catch (e) {
        print('Column already exists: $e');
      }
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // ─── Config Methods ──────────────────────────────────────────────────────
  Future<LauncherConfig> loadConfig() async {
    final db = await database;

    final result = await db.query(
      'LauncherConfig',
      columns: [
        'BackgroundColor',
        'SidebarColor',
        'AccentColor',
        'UseCoverArtView',
        'WallpaperPath',
      ],
      where: 'Id = 1',
    );

    if (result.isNotEmpty) {
      final config = LauncherConfig.fromMap(result.first);
      final apps = await loadApps();
      return LauncherConfig(
        backgroundColor: config.backgroundColor,
        sidebarColor: config.sidebarColor,
        accentColor: config.accentColor,
        useCoverArtView: config.useCoverArtView,
        wallpaperPath: config.wallpaperPath,
        apps: apps,
      );
    }

    return LauncherConfig(apps: await loadApps());
  }

  Future<void> saveConfig(LauncherConfig config) async {
    final db = await database;
    await db.update(
      'LauncherConfig',
      config.toMap(),
      where: 'Id = 1',
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ─── App Methods ─────────────────────────────────────────────────────────
  Future<List<AppItem>> loadApps() async {
    final db = await database;

    final result = await db.query('Apps', orderBy: 'Category, Name');

    return result.map((row) => AppItem.fromMap(row)).toList();
  }

  Future<int> addApp(AppItem app) async {
    final db = await database;
    return await db.insert(
      'Apps',
      app.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateApp(AppItem app) async {
    if (app.id == null) {
      throw Exception('Cannot update app without Id');
    }

    final db = await database;
    await db.update('Apps', app.toMap(), where: 'Id = ?', whereArgs: [app.id]);
  }

  Future<void> deleteApp(int appId) async {
    final db = await database;
    await db.delete('Apps', where: 'Id = ?', whereArgs: [appId]);
  }

  Future<AppItem?> getAppById(int appId) async {
    final db = await database;

    final result = await db.query('Apps', where: 'Id = ?', whereArgs: [appId]);

    if (result.isNotEmpty) {
      return AppItem.fromMap(result.first);
    }
    return null;
  }

  Future<AppItem?> getAppByName(String name) async {
    final db = await database;

    final result = await db.query('Apps', where: 'Name = ?', whereArgs: [name]);

    if (result.isNotEmpty) {
      return AppItem.fromMap(result.first);
    }
    return null;
  }

  // ─── Running Process Tracking ────────────────────────────────────────────
  Future<void> logProcessStart(
    int appId,
    int processId,
    String category,
  ) async {
    final db = await database;
    await db.insert('RunningProcesses', {
      'ProcessId': processId,
      'AppId': appId,
      'Category': category,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> logProcessEnd(int processId) async {
    final db = await database;
    await db.delete(
      'RunningProcesses',
      where: 'ProcessId = ?',
      whereArgs: [processId],
    );
  }

  Future<List<(int processId, String category)>>
  getRunningGameProcesses() async {
    final db = await database;

    final result = await db.query(
      'RunningProcesses',
      columns: ['ProcessId', 'Category'],
      where: 'Category = ?',
      whereArgs: ['Games'],
    );

    return result
        .map((row) => (row['ProcessId'] as int, row['Category'] as String))
        .toList();
  }

  Future<int> getRunningProcessCount({String? category}) async {
    final db = await database;

    if (category == null) {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM RunningProcesses',
      );
      return (result.first['count'] as int?) ?? 0;
    } else {
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM RunningProcesses WHERE Category = ?',
        [category],
      );
      return (result.first['count'] as int?) ?? 0;
    }
  }
}
