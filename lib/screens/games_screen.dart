import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/screens/__addprogram.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/widgets/table_widget.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<AppItem> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final db = DatabaseService();
    final apps = await db.loadApps();
    setState(() {
      _apps = apps; // Load all apps, but the widget will filter for games
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'), // Changed to 'Games' instead of 'Applications'
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadApps,
          ),
        ],
      ),
      body: Column(
        children: [
          // Add a stats header if you want
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_apps.where((a) => a.category == 'Games').length} games',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table - FILTERED FOR GAMES ONLY
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppTableWidget(
                    apps: _apps,
                    categoryFilter: 'Games', // This filters to show only games
                  ),
          ),
        ],
      ),
    );
  }
}