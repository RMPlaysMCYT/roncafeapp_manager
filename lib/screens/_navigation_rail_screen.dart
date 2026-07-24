import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/screens/annoucement_screen.dart';
import 'package:roncafeapp_manager/screens/application_screen.dart';
import 'package:roncafeapp_manager/screens/customization_screen.dart';
import 'package:roncafeapp_manager/screens/dashboard_screen.dart';
import 'package:roncafeapp_manager/screens/games_screen.dart';
import 'package:roncafeapp_manager/screens/settings_screen.dart';

class RonCafeNavigationBarWidget extends StatefulWidget {
  const RonCafeNavigationBarWidget({super.key});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<RonCafeNavigationBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ApplicationScreen(),
    const GamesScreen(),
    const CustomizeScreen(),
    const AnnouncementScreen(),
    const SettingsScreen(),
  ];

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(
      icon: Icon(Icons.control_point),
      label: Text('Applications'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.checklist),
      label: Text('Games'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.palette),
      label: Text('Customize'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.notifications),
      label: Text('Announcements'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
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
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                  indent: 12.0,
                  endIndent: 12.0,
                ),
                const SizedBox(height: 8.0), // Spacer equivalent
                Image.asset(
                  'assets/icons/bottom_icon.png',
                  width: 40.0,
                  height: 40.0,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 40.0);
                  },
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'Created By Ronnel S. Mitra',
                  style: TextStyle(fontSize: 10.0, color: Colors.grey),
                ),
              ],
            ),
          ),
          selectedIconTheme: IconThemeData(
            color: Colors.blue,
            size: 40.0, // Resizes the selected icon
          ),
          unselectedIconTheme: IconThemeData(
            color: Colors.grey,
            size: 32.0, // Resizes unselected icons
          ),
          labelType: NavigationRailLabelType.selected,
          destinations: _destinations,
        ),
        Expanded(child: _screens[_selectedIndex]),
      ],
    );
  }
}
