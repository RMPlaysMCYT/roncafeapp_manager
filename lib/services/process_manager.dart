// services/process_manager.dart
import 'dart:io';
import 'package:flutter/services.dart';

class ProcessManager {
  static const MethodChannel _channel = MethodChannel('cafe_launcher/process');

  static Future<void> startProcess(String path, {String? arguments}) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        // Try platform-specific method first
        await _channel.invokeMethod('startProcess', {
          'path': path,
          'arguments': arguments,
        });
      } catch (e) {
        // Fallback to Dart Process
        await Process.start(
          path,
          arguments?.split(' ') ?? [],
          mode: ProcessStartMode.detached,
        );
      }
    }
  }

  static Future<List<int>> getRunningProcesses() async {
    try {
      final result = await _channel.invokeMethod('getRunningProcesses');
      return List<int>.from(result ?? []);
    } catch (e) {
      // Fallback to Dart Process
      final processes = await Process.run('tasklist', ['/FO', 'CSV']);
      return processes.stdout
          .toString()
          .split('\n')
          .map((line) {
            final parts = line.split(',');
            if (parts.length > 1) {
              return int.tryParse(parts[1].replaceAll('"', '').trim()) ?? 0;
            }
            return 0;
          })
          .where((id) => id > 0)
          .toList();
    }
  }
}
