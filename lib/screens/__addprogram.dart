// screens/add_program_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:roncafeapp_manager/models/app_item.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/services/sync_service.dart';
import 'package:provider/provider.dart';

class AddProgramScreen extends StatefulWidget {
  final AppItem? editingApp;
  const AddProgramScreen({super.key, this.editingApp});

  @override
  State<AddProgramScreen> createState() => _AddProgramScreenState();
}

class _AddProgramScreenState extends State<AddProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _executionPathController = TextEditingController();
  final _iconPathController = TextEditingController();
  final _coverArtPathController = TextEditingController();

  String _selectedCategory = 'Games';
  String _iconPath = '/Assets/placeholder.png';
  String _coverArtPath = '/Assets/placeholder.png';
  bool _isLoading = false;
  bool _isEditing = false;

  final List<CategoryOption> _categories = [
    const CategoryOption('Games', Icons.sports_esports_rounded, Colors.green),
    const CategoryOption('Programming', Icons.code_rounded, Colors.blue),
    const CategoryOption('Creative', Icons.brush_rounded, Colors.purple),
    const CategoryOption('Entertainment', Icons.movie_rounded, Colors.orange),
    const CategoryOption('Documents', Icons.folder_rounded, Colors.amber),
    const CategoryOption('Utilities', Icons.build_rounded, Colors.grey),
    const CategoryOption('Other', Icons.apps_rounded, Colors.teal),
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.editingApp != null;
    if (_isEditing) {
      _nameController.text = widget.editingApp!.name;
      _executionPathController.text = widget.editingApp!.executionPath;
      _iconPath = widget.editingApp!.iconPath;
      _coverArtPath = widget.editingApp!.coverArtPath;
      _selectedCategory = widget.editingApp!.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _executionPathController.dispose();
    _iconPathController.dispose();
    _coverArtPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Program' : 'Add Program',
          style: const TextStyle(fontWeight: FontWeight(700)),
        ),
        backgroundColor: const Color(0xFF181825),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditing ? 'Edit Program' : 'Add New Program',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isEditing
                          ? 'Update the program details below.'
                          : 'Fill in the details below to add a new program.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 32),

                    // Program Name
                    _buildTextField(
                      controller: _nameController,
                      label: 'Program Name',
                      hint: 'Enter program name',
                      icon: Icons.drive_file_rename_outline_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a program name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Selection
                    _buildSectionTitle('Category', Icons.category_rounded),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category.name;
                        return FilterChip(
                          label: Text(category.name),
                          avatar: Icon(
                            category.icon,
                            size: 18,
                            color: isSelected ? Colors.white : category.color,
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category.name;
                            });
                          },
                          backgroundColor: Colors.grey[900],
                          selectedColor: category.color.withValues(alpha: 0.3),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[300],
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? category.color
                                : Colors.grey[700]!,
                            width: 1.5,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Execution Path
                    _buildSectionTitle(
                      'Execution Path',
                      Icons.folder_open_rounded,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _executionPathController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Select executable file...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF89B4FA),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.computer_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an executable file';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _pickExecutable,
                          icon: const Icon(Icons.browse_gallery_rounded),
                          label: const Text('Browse'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF89B4FA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Icon Path
                    _buildSectionTitle('Icon (Optional)', Icons.image_rounded),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _iconPathController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Select icon image...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF89B4FA),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.image_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _pickIcon,
                          icon: const Icon(Icons.browse_gallery_rounded),
                          label: const Text('Browse'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF89B4FA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cover Art Path
                    _buildSectionTitle(
                      'Cover Art (Optional)',
                      Icons.art_track_rounded,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _coverArtPathController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Select cover art image...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              filled: true,
                              fillColor: Colors.grey[900],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[700]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF89B4FA),
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.art_track_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _pickCoverArt,
                          icon: const Icon(Icons.browse_gallery_rounded),
                          label: const Text('Browse'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF89B4FA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Preview
                    _buildPreview(),
                    const SizedBox(height: 24),

                    // Sync Info
                    _buildSyncInfo(),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _saveProgram,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF89B4FA),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _isEditing ? 'Update & Sync' : 'Add & Sync',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.preview_rounded, color: Color(0xFF89B4FA)),
              const SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.apps_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nameController.text.isEmpty
                          ? 'Program Name'
                          : _nameController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _selectedCategory,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_rounded, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Auto-sync to Avalonia Client',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Changes will be synced to the client database',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[900],
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF89B4FA), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF89B4FA), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Future<void> _pickExecutable() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: Platform.isWindows
            ? ['exe', 'msi', 'bat', 'cmd']
            : Platform.isLinux
            ? ['desktop', 'sh', 'bin']
            : ['app', 'dmg'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _executionPathController.text = result.files.single.path!;
        });
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e', Colors.red);
    }
  }

  Future<void> _pickIcon() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'ico', 'webp'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _iconPath = result.files.single.path!;
          _iconPathController.text = result.files.single.path!;
        });
      }
    } catch (e) {
      _showSnackBar('Error picking icon: $e', Colors.red);
    }
  }

  Future<void> _pickCoverArt() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'svg'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _coverArtPath = result.files.single.path!;
          _coverArtPathController.text = result.files.single.path!;
        });
      }
    } catch (e) {
      _showSnackBar('Error picking cover art: $e', Colors.red);
    }
  }

  Future<void> _saveProgram() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final app = AppItem(
        id: _isEditing ? widget.editingApp!.id : null,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        executionPath: _executionPathController.text,
        iconPath: _iconPath,
        coverArtPath: _coverArtPath,
        lastModified: DateTime.now(),
      );

      final db = DatabaseService();

      if (_isEditing) {
        await db.updateApp(app);
        _showSnackBar('Program updated successfully!', Colors.green);
      } else {
        await db.addApp(app);
        _showSnackBar('Program added successfully!', Colors.green);
      }

      // Auto-sync to client
      final syncService = Provider.of<SyncService>(context, listen: false);
      await syncService.syncToClient();

      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Error saving program: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: Color(0xFF89B4FA)),
            SizedBox(width: 8),
            Text('How to Add a Program'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              '1. Program Name',
              'Enter the display name of the program.',
            ),
            const Divider(),
            _buildHelpItem(
              '2. Category',
              'Select the appropriate category for organization.',
            ),
            const Divider(),
            _buildHelpItem(
              '3. Execution Path',
              'Browse and select the executable file.',
            ),
            const Divider(),
            _buildHelpItem(
              '4. Auto-Sync',
              'Programs are automatically synced to the Avalonia client.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class CategoryOption {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryOption(this.name, this.icon, this.color);
}
