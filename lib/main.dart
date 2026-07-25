import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:roncafeapp_manager/services/sync_service.dart';
import 'package:roncafeapp_manager/screens/_navigation_rail_screen.dart';

void main() {
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize sqflite_common_ffi for desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SyncService())],
      child: MaterialApp(
        title: 'RonCafe App Manager',
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF89B4FA),
          scaffoldBackgroundColor: const Color(0xFF1E1E2E),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF181825)),
        ),
        home: const RonCafeNavigationBarWidget(),
      ),
    );
  }
}
