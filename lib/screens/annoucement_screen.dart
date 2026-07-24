// screens/announcement_screen.dart
import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/widgets/dashboard_cards1.dart';
import 'package:roncafeapp_manager/widgets/searchBarWidget.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Announcements!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Game of the Day',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Searchbarwidget(), // Fixed naming
                const SizedBox(width: 128),
                Expanded(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: [
                      dashboardCards1(text: "Test", value: "12"),
                      dashboardCards1(text: "Test", value: "12"),
                      dashboardCards1(text: "Test", value: "12"),
                      dashboardCards1(text: "Test", value: "12"),
                      dashboardCards1(text: "Test", value: "12"),
                      dashboardCards1(text: "Test", value: "12"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
