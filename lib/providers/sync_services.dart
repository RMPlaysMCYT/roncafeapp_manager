// services/sync_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/models/app_item.dart';

class SyncService extends ChangeNotifier {
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String? _syncError;
  int _syncedAppsCount = 0;

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get syncError => _syncError;
  int get syncedAppsCount => _syncedAppsCount;

  // Get the C# client database path
  Future<String> getClientDbPath() async {
    final clientPath = DatabaseService.getClientDbPath();

    // Ensure directory exists
    final dir = Directory(path.dirname(clientPath));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return clientPath;
  }

  // Sync apps from Flutter Admin to Avalonia Client
  Future<void> syncToClient() async {
    _isSyncing = true;
    _syncError = null;
    _syncedAppsCount = 0;
    notifyListeners();

    try {
      // Get the client database path
      final clientDbPath = await getClientDbPath();

      // Create a copy of the database at the client location
      final localDb = DatabaseService();
      final apps = await localDb.loadApps();

      // Open the client database directly
      final db = await DatabaseService.fromPath(clientDbPath).database;

      // Sync apps to client database
      for (final app in apps) {
        // Check if app exists
        final existing = await db.query(
          'Apps',
          where: 'Name = ?',
          whereArgs: [app.name],
        );

        if (existing.isEmpty) {
          // Insert new app
          await db.insert('Apps', app.toMap());
          _syncedAppsCount++;
        } else {
          // Update existing app
          await db.update(
            'Apps',
            app.toMap(),
            where: 'Id = ?',
            whereArgs: [existing.first['Id']],
          );
          _syncedAppsCount++;
        }
      }

      // Also sync config (theme, wallpaper)
      final config = await localDb.loadConfig();
      await db.update('LauncherConfig', config.toMap(), where: 'Id = 1');

      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _syncError = e.toString();
      _isSyncing = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sync config only (theme, wallpaper)
  Future<void> syncConfigToClient() async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final clientDbPath = await getClientDbPath();
      final localDb = DatabaseService();
      final config = await localDb.loadConfig();

      final db = await DatabaseService.fromPath(clientDbPath).database;
      await db.update('LauncherConfig', config.toMap(), where: 'Id = 1');

      _lastSyncTime = DateTime.now();
      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _syncError = e.toString();
      _isSyncing = false;
      notifyListeners();
      rethrow;
    }
  }

  // Get sync status
  Future<Map<String, dynamic>> getSyncStatus() async {
    try {
      final clientPath = await getClientDbPath();
      final exists = await File(clientPath).exists();

      if (exists) {
        final file = File(clientPath);
        final stat = await file.stat();
        return {
          'path': clientPath,
          'exists': true,
          'size': stat.size,
          'modified': stat.modified,
          'lastSync': _lastSyncTime,
        };
      }

      return {'path': clientPath, 'exists': false, 'lastSync': _lastSyncTime};
    } catch (e) {
      return {
        'path': 'Unknown',
        'exists': false,
        'error': e.toString(),
        'lastSync': _lastSyncTime,
      };
    }
  }

  Future<void> autoSync() async {
    try {
      // Admin always syncs when changes are made
      await syncToClient();
    } catch (e) {
      print('Auto-sync failed: $e');
    }
  }
}
