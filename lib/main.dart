// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/services/sync_service.dart';
import 'package:roncafeapp_manager/screens/_navigation_rail_screen.dart';

void main() {
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
        theme: ThemeData.dark(),
        home: const RonCafeNavigationBarWidget(),
      ),
    );
  }
}
