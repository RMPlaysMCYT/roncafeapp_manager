import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/screens/__addprogram.dart';
import 'package:roncafeapp_manager/screens/__customize_screen.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/widgets/dashboard_cards2.dart';
import 'package:roncafeapp_manager/widgets/quick_action_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _appCount = 0;
  int _gameCount = 0;
  int _runningCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

Future<void> _loadStats() async {
  final db = DatabaseService();
  final apps = await db.loadApps();
  setState(() {
    _appCount = apps.length;
    _gameCount = apps.where((a) => a.category == 'Games').length;
    // _runningCount = apps.where((a) => a.isRunning == true).length; // Add this
    _isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      DashboardCards2(
                        title: '📱 Total Apps',
                        value: _appCount.toString(),
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      DashboardCards2(
                        title: '🎮 Games',
                        value: _gameCount.toString(),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      DashboardCards2(
                        title: '🔄 Running',
                        value: _runningCount.toString(),
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      DashboardCards2(
                        title: '📊 Categories',
                        value: '${_appCount > 0 ? 1 : 0}',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📌 Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          QuickActionWidget(
                            text: '➕ Add New Application',
                            icon: Icons.add_rounded,
                            backgroundColor: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProgramScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          QuickActionWidget(
                            text: '🔄 Sync with Avalonia',
                            icon: Icons.sync_rounded,
                            backgroundColor: Colors.green,
                            onTap: () {
                              // Trigger sync
                            },
                          ),
                          const Divider(),
                          QuickActionWidget(
                            text: '🎨 Customize Theme',
                            icon: Icons.palette_rounded,
                            backgroundColor: Colors.purple,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CustomizeScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
