import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roncafeapp_manager/services/database_services.dart';

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
                      _buildStatCard(
                        '📱 Total Apps',
                        _appCount.toString(),
                        Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        '🎮 Games',
                        _gameCount.toString(),
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                        '🔄 Running',
                        _runningCount.toString(),
                        Colors.orange,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        '📊 Categories',
                        '${_appCount > 0 ? 1 : 0}',
                        Colors.purple,
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
                          _buildQuickAction(
                            '➕ Add New Application',
                            Icons.add_rounded,
                            Colors.blue,
                            () {
                              // Navigate to Applications tab
                              // You can use a GlobalKey or callback
                            },
                          ),
                          const Divider(),
                          _buildQuickAction(
                            '🔄 Sync with Avalonia',
                            Icons.sync_rounded,
                            Colors.green,
                            () {
                              // Trigger sync
                            },
                          ),
                          const Divider(),
                          _buildQuickAction(
                            '🎨 Customize Theme',
                            Icons.palette_rounded,
                            Colors.purple,
                            () {
                              // Navigate to Customize tab
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

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    // Fixed: Wrap ListTile with Material and add a background
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
        // Add these to fix the warning
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
