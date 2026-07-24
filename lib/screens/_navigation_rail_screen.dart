// screens/_navigation_rail_screen.dart
import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/screens/annoucement_screen.dart';
// Fix this - change 'annoucement_screen.dart' to 'announcement_screen.dart'
import 'package:roncafeapp_manager/screens/application_screen.dart';
import 'package:roncafeapp_manager/screens/customization_screen.dart';
import 'package:roncafeapp_manager/screens/dashboard_screen.dart';
import 'package:roncafeapp_manager/screens/games_screen.dart';
import 'package:roncafeapp_manager/screens/settings_screen.dart';
import 'package:roncafeapp_manager/widgets/sync_status_widget.dart'; // Add this

class RonCafeNavigationBarWidget extends StatefulWidget {
  const RonCafeNavigationBarWidget({super.key});

  @override
  State<RonCafeNavigationBarWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<RonCafeNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ApplicationScreen(),
    const GamesScreen(),
    const CustomizeScreen(),
    const AnnouncementScreen(), // Fixed spelling
    const SettingsScreen(),
  ];

  final List<NavigationRailDestination> _destinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard_rounded),
      label: Text('Dashboard'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.apps_rounded),
      label: Text('Applications'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.sports_esports_rounded),
      label: Text('Games'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.palette_rounded),
      label: Text('Customize'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.announcement_rounded),
      label: Text('Announcements'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_rounded),
      label: Text('Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            minWidth: 72.0,
            extended: false,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            leading: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.asset(
                'assets/icons/3_objectsicon.png',
                width: 80.0,
                height: 80.0,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.apps_rounded, size: 80);
                },
              ),
            ),
            trailing: const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 1.0,
                    color: Colors.grey,
                    indent: 12.0,
                    endIndent: 12.0,
                  ),
                  SizedBox(height: 8.0),
                  SyncStatusWidget(),
                  SizedBox(height: 4.0),
                  Text(
                    'Created By Ronnel S. Mitra',
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            selectedIconTheme: const IconThemeData(
              color: Color(0xFF89B4FA),
              size: 40.0,
            ),
            unselectedIconTheme: const IconThemeData(
              color: Colors.grey,
              size: 32.0,
            ),
            labelType: NavigationRailLabelType.selected,
            destinations: _destinations,
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}
