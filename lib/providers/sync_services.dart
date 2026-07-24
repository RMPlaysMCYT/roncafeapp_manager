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

  // Platform-specific database paths
  String get _avalonDbPath {
    if (Platform.isWindows) {
      return r'C:\RonCafeLauncher\Data\RonCafeLauncher.db';
    } else if (Platform.isLinux) {
      return '/opt/roncafelauncher/data/RonCafeLauncher.db';
    } else if (Platform.isMacOS) {
      return '/Library/Application Support/RonCafeLauncher/RonCafeLauncher.db';
    } else {
      // Mobile or unknown platform - use local path
      return '';
    }
  }

  // Get the Avalonia database path for the current platform
  Future<String> getAvaloniaDbPath() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Check if the default path exists
      if (await File(_avalonDbPath).exists()) {
        return _avalonDbPath;
      }

      // Try alternative paths
      if (Platform.isWindows) {
        // Try ProgramData
        final programData = Platform.environment['ProgramData'];
        if (programData != null) {
          final altPath = path.join(
            programData,
            'RonCafeLauncher',
            'Data',
            'RonCafeLauncher.db',
          );
          if (await File(altPath).exists()) {
            return altPath;
          }
        }
      }

      if (Platform.isLinux) {
        // Try /var/lib
        final varPath = '/var/lib/roncafelauncher/data/RonCafeLauncher.db';
        if (await File(varPath).exists()) {
          return varPath;
        }

        // Try user home
        final home = Platform.environment['HOME'];
        if (home != null) {
          final homePath = path.join(
            home,
            '.roncafelauncher',
            'data',
            'RonCafeLauncher.db',
          );
          if (await File(homePath).exists()) {
            return homePath;
          }
        }
      }
    }

    // Fallback to application documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDir.path, 'RonCafeLauncher.db');

    // Create a copy from local if exists
    final localDb = await _getLocalDbPath();
    if (await File(localDb).exists()) {
      await File(localDb).copy(dbPath);
    }

    return dbPath;
  }

  Future<String> _getLocalDbPath() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cafeDir = Directory(path.join(appDir.path, 'CafeLauncher'));
    if (!await cafeDir.exists()) {
      await cafeDir.create(recursive: true);
    }
    return path.join(cafeDir.path, 'CafeLauncher.db');
  }

  Future<void> syncFromAvalonia() async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final avalonDbPath = await getAvaloniaDbPath();

      if (!await File(avalonDbPath).exists()) {
        throw Exception('Avalonia database not found at: $avalonDbPath');
      }

      // Create a temporary connection to Avalonia DB
      final tempDbPath = await _getLocalDbPath();
      await File(avalonDbPath).copy(tempDbPath);

      // Load apps from Avalonia DB
      final tempDb = await DatabaseService.fromPath(tempDbPath);
      final avalonApps = await tempDb.loadApps();
      await tempDb.close();

      // Merge with local DB
      final localDb = DatabaseService();
      for (final app in avalonApps) {
        final existing = await localDb.getAppByName(app.name);
        if (existing == null) {
          await localDb.addApp(app);
          _syncedAppsCount++;
        } else if (app.lastModified != null &&
            existing.lastModified != null &&
            app.lastModified!.isAfter(existing.lastModified!)) {
          await localDb.updateApp(app);
          _syncedAppsCount++;
        }
      }

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

  Future<void> syncToAvalonia() async {
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final avalonDbPath = await getAvaloniaDbPath();

      if (!await File(avalonDbPath).exists()) {
        // Create directory if it doesn't exist
        final dir = Directory(path.dirname(avalonDbPath));
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
      }

      // Get local apps
      final localDb = DatabaseService();
      final localApps = await localDb.loadApps();

      // Copy to Avalonia DB
      final tempDbPath = await _getLocalDbPath();

      // Use the local database as source
      if (await File(tempDbPath).exists()) {
        await File(tempDbPath).copy(avalonDbPath);
        _lastSyncTime = DateTime.now();
        _syncedAppsCount = localApps.length;
      }

      _isSyncing = false;
      notifyListeners();
    } catch (e) {
      _syncError = e.toString();
      _isSyncing = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> autoSync() async {
    try {
      // Check if Avalonia DB exists and is newer
      final avalonDbPath = await getAvaloniaDbPath();
      if (await File(avalonDbPath).exists()) {
        final avalonFile = File(avalonDbPath);
        final avalonStat = await avalonFile.stat();
        final lastSync = _lastSyncTime ?? DateTime(2000);

        if (avalonStat.modified.isAfter(lastSync)) {
          await syncFromAvalonia();
        }
      }
    } catch (e) {
      // Silent fail for auto-sync
      print('Auto-sync failed: $e');
    }
  }
}
