import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/providers/database_services.dart';
import 'package:roncafeapp_manager/providers/sync_services.dart';
import 'package:roncafeapp_manager/screens/_navigation_rail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
          dispose: (_, db) => db.close(),
        ),
        ChangeNotifierProvider<SyncService>(create: (_) => SyncService()),
      ],
      child: MaterialApp(
        title: 'RonCafe Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1E1E2E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF181825),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          navigationRailTheme: const NavigationRailThemeData(
            backgroundColor: Color(0xFF181825),
            selectedIconTheme: IconThemeData(
              color: Color(0xFF89B4FA),
              size: 40,
            ),
            unselectedIconTheme: IconThemeData(color: Colors.grey, size: 32),
            selectedLabelTextStyle: TextStyle(color: Color(0xFF89B4FA)),
            unselectedLabelTextStyle: TextStyle(color: Colors.grey),
          ),
        ),
        home: const RonCafeNavigationBarWidget(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreenState extends StatefulWidget {
  const SplashScreenState({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenState> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RonCafeNavigationBarWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/3_objectsicon.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
