import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/screens/__addprogram.dart';
import 'package:roncafeapp_manager/services/database_services.dart';

class AppTableWidget extends StatelessWidget {
  final List<AppItem> apps;
  final String? categoryFilter;

  const AppTableWidget({super.key, required this.apps, this.categoryFilter});

  // Get filtered apps (non-games by default)
  List<AppItem> get _filteredApps {
    if (categoryFilter != null) {
      return apps.where((app) => app.category == categoryFilter).toList();
    }
    // Default: exclude 'Games' category
    return apps.where((app) => app.category != 'Games').toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _filteredApps;

    if (filteredApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'No applications found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 150,
          horizontalMargin: 12,
          headingRowColor: MaterialStateProperty.resolveWith(
            (states) => Colors.grey[900],
          ),
          columns: const [
            DataColumn(
              label: Text(
                'Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Path',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          rows: filteredApps.map((app) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      // Icon preview
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: app.iconPath.isNotEmpty
                            ? Image.network(
                                app.iconPath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.apps_rounded, size: 20),
                              )
                            : const Icon(Icons.apps_rounded, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(app.name),
                    ],
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        app.category,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      app.category,
                      style: TextStyle(
                        color: _getCategoryColor(app.category),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    app.executionPath,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: Colors.blue,
                        ),
                        onPressed: () => _onEditApp(context, app),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          size: 18,
                          color: Colors.red,
                        ),
                        onPressed: () => _onDeleteApp(context, app),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'productivity':
        return Colors.blue;
      case 'utilities':
        return Colors.green;
      case 'media':
        return Colors.purple;
      case 'development':
        return Colors.orange;
      case 'education':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _onEditApp(BuildContext context, AppItem app) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProgramScreen(editingApp: app),
      ),
    );
  }

  void _onDeleteApp(BuildContext context, AppItem app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Application'),
        content: Text('Are you sure you want to delete "${app.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first

              // Delete from database
              final db = DatabaseService();
              await db.deleteApp(app.id!); // Assuming you have a delete method

              // Show confirmation
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Deleted: ${app.name}')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
