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
  int _syncAppsCount = 0;

  bool get isSyncing => _isSyncing;
  DateTime get lastSyncTime => _lastSyncTime;
  String get syncError => _syncError;
  int get syncAppsCount => _syncAppsCount;

  String get _avalonDbPath {
    if (Platform.isWindows) {
    } else if (Platform.isMacOS) {
    } else if (Platform.isLinux) {
    } else {
      return '';
    }
  }

  Future<String> getAvalonDbPath() async {}
}
