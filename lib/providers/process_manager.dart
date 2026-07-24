import 'package:flutter/services.dart';

class ProcessManager {
  static const MethodChannel _channel = MethodChannel('cafe_launcher/process');

  static Future<void> startProcess(String path) async {
    await _channel.invokeMethod('startProcess', {'path': path});
  }

  static Future<List<dynamic>> getRunningProcesses() async {
    return await _channel.invokeMethod('getRunningProcesses');
  }
}