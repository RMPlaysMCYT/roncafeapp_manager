// screens/customize_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:roncafeapp_manager/services/database_services.dart';
import 'package:roncafeapp_manager/models/launcher_config.dart';
import 'package:file_picker/file_picker.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  LauncherConfig? _config;
  bool _isLoading = true;
  String? _error;

  // Theme options matching C# client
  final List<ThemeOption> _themes = [
    const ThemeOption('Mocha', '#1E1E2E', '#181825', '#89B4FA'),
    const ThemeOption('Ocean', '#0D1B2A', '#0A1220', '#64DFDF'),
    const ThemeOption('Forest', '#1A2318', '#141C12', '#A6E3A1'),
    const ThemeOption('Sunset', '#2E1A1A', '#241414', '#FAB387'),
    const ThemeOption('Midnight', '#0A0A0F', '#07070B', '#CBA6F7'),
  ];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final db = DatabaseService();
      _config = await db.loadConfig();
      setState(() => _error = null);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Launcher',
          style: TextStyle(fontWeight: FontWeight(700)),),
        backgroundColor: const Color(0xFF181825),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadConfig,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading config',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadConfig,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _config == null
          ? const Center(child: Text('No configuration found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Customize Your Launcher',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Changes will sync with the Avalonia client.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 32),

                  // Current Theme Preview
                  _buildThemePreview(),
                  const SizedBox(height: 32),

                  // Theme Selection
                  _buildSectionTitle('Select Theme', Icons.palette_rounded),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _themes.map((theme) {
                      return _buildThemeCard(theme);
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Cover Art View Toggle
                  _buildSectionTitle(
                    'Display Options',
                    Icons.view_agenda_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildToggleCard(),
                  const SizedBox(height: 32),

                  // Wallpaper
                  _buildSectionTitle('Wallpaper', Icons.wallpaper_rounded),
                  const SizedBox(height: 16),
                  _buildWallpaperCard(),
                  const SizedBox(height: 32),

                  // Database Info
                  _buildDatabaseInfo(),
                  const SizedBox(height: 32),

                  // Sync Status
                  _buildSyncInfo(),
                ],
              ),
            ),
    );
  }

  Widget _buildThemePreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(
          int.parse(_config!.backgroundColor.replaceFirst('#', '0xFF')),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse(_config!.sidebarColor.replaceFirst('#', '0xFF')),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.apps_rounded,
                  color: Color(
                    int.parse(_config!.accentColor.replaceFirst('#', '0xFF')),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Theme Preview',
                      style: TextStyle(
                        color: Color(
                          int.parse(
                            _config!.accentColor.replaceFirst('#', '0xFF'),
                          ),
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Background: ${_config!.backgroundColor}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Color(
                int.parse(_config!.accentColor.replaceFirst('#', '0xFF')),
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildColorChip(_config!.backgroundColor, 'BG'),
              const SizedBox(width: 8),
              _buildColorChip(_config!.sidebarColor, 'Sidebar'),
              const SizedBox(width: 8),
              _buildColorChip(_config!.accentColor, 'Accent'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String colorHex, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildThemeCard(ThemeOption theme) {
    final isSelected =
        _config!.backgroundColor == theme.backgroundColor &&
        _config!.sidebarColor == theme.sidebarColor &&
        _config!.accentColor == theme.accentColor;

    return GestureDetector(
      onTap: () => _applyTheme(theme),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color(int.parse(theme.accentColor.replaceFirst('#', '0xFF')))
                : Colors.grey[700]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(
                        theme.backgroundColor.replaceFirst('#', '0xFF'),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(theme.sidebarColor.replaceFirst('#', '0xFF')),
                    ),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[600]!),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(theme.accentColor.replaceFirst('#', '0xFF')),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              theme.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF89B4FA),
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.grid_view_rounded, color: Color(0xFF89B4FA)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cover Art View',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Show apps with cover art in a grid layout',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: _config!.useCoverArtView,
            onChanged: (value) {
              setState(() {
                _config = _config!.copyWith(useCoverArtView: value);
              });
              _saveConfig();
            },
            activeColor: const Color(0xFF89B4FA),
          ),
        ],
      ),
    );
  }

  Widget _buildWallpaperCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _config!.wallpaperPath.isNotEmpty
                          ? 'Wallpaper Set'
                          : 'No Wallpaper',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_config!.wallpaperPath.isNotEmpty)
                      Text(
                        _config!.wallpaperPath,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickWallpaper,
                    icon: const Icon(Icons.image_rounded),
                    label: const Text('Browse'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF89B4FA),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (_config!.wallpaperPath.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _clearWallpaper,
                      icon: const Icon(Icons.clear_rounded),
                      color: Colors.red,
                      tooltip: 'Clear Wallpaper',
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (_config!.wallpaperPath.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(_config!.wallpaperPath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDatabaseInfo() {
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
              const Icon(Icons.storage_rounded, color: Color(0xFF89B4FA)),
              const SizedBox(width: 12),
              const Text(
                'Database Information',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
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
                const Icon(Icons.folder_rounded, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DatabaseService.getClientDbPath(),
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Copy path to clipboard
                    // You'll need to add clipboard package for this
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                  tooltip: 'Copy path',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Client is in read-only mode. Add/Edit/Delete apps from the admin panel.',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_rounded, color: Color(0xFF89B4FA)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configuration Synced with Avalonia Client',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Changes are automatically saved to the shared database',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: Colors.green[400]),
        ],
      ),
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

  Future<void> _applyTheme(ThemeOption theme) async {
    setState(() {
      _config = _config!.copyWith(
        backgroundColor: theme.backgroundColor,
        sidebarColor: theme.sidebarColor,
        accentColor: theme.accentColor,
      );
    });
    await _saveConfig();
  }

  Future<void> _pickWallpaper() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final path = result.files.single.path!;
        setState(() {
          _config = _config!.copyWith(wallpaperPath: path);
        });
        await _saveConfig();
      }
    } catch (e) {
      _showSnackBar('Error picking wallpaper: $e', Colors.red);
    }
  }

  Future<void> _clearWallpaper() async {
    setState(() {
      _config = _config!.copyWith(wallpaperPath: '');
    });
    await _saveConfig();
  }

  // FIXED: Use saveConfig instead of saveLauncherConfig
  Future<void> _saveConfig() async {
    if (_config == null) return;
    try {
      final db = DatabaseService();
      await db.saveConfig(_config!);
      _showSnackBar('Configuration saved successfully!', Colors.green);
    } catch (e) {
      _showSnackBar('Error saving config: $e', Colors.red);
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
}

// Helper class for themes
class ThemeOption {
  final String name;
  final String backgroundColor;
  final String sidebarColor;
  final String accentColor;

  const ThemeOption(
    this.name,
    this.backgroundColor,
    this.sidebarColor,
    this.accentColor,
  );
}
