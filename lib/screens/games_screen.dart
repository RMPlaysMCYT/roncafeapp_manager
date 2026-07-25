import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/screens/__addprogram.dart';
import 'package:roncafeapp_manager/widgets/table_widget.dart';
import 'package:roncafeapp_manager/services/database_services.dart';

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
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadApps,
          ),
        ],
      ),
      body: Column(
        children: [
          // Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppTableWidget(apps: _apps),
          ),
        ],
      ),
    );
  }
}
