import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/widgets/table_widget.dart';
import 'package:roncafeapp_manager/services/database_services.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  List<AppItem> _apps = [];
  bool _isLoading = true;
  String? _selectedCategory;
  final List<String> _categories = ['All', 'Programming', 'Creative', 'Entertainment', 'Document', 'Utilities', 'Other'];

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
          // Category filter dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Filter: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: const Text('Select category'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category == 'All' ? null : category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Table
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppTableWidget(
                    apps: _apps,
                    categoryFilter: _selectedCategory,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add application screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new application')),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add App'),
      ),
    );
  }
}