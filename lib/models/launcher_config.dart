// models/launcher_config.dart
import 'package:roncafeapp_manager/models/app_item.dart';

class LauncherConfig {
  final String backgroundColor;
  final String sidebarColor;
  final String accentColor;
  final bool useCoverArtView;
  final String wallpaperPath;
  final List<AppItem> apps;

  LauncherConfig({
    this.backgroundColor = '#1E1E2E',
    this.sidebarColor = '#181825',
    this.accentColor = '#89B4FA',
    this.useCoverArtView = false,
    this.wallpaperPath = '',
    this.apps = const [],
  });

  Map<String, dynamic> toMap() => {
    'BackgroundColor': backgroundColor,
    'SidebarColor': sidebarColor,
    'AccentColor': accentColor,
    'UseCoverArtView': useCoverArtView ? 1 : 0,
    'WallpaperPath': wallpaperPath,
  };

  factory LauncherConfig.fromMap(Map<String, dynamic> map) => LauncherConfig(
    backgroundColor: map['BackgroundColor'] ?? '#1E1E2E',
    sidebarColor: map['SidebarColor'] ?? '#181825',
    accentColor: map['AccentColor'] ?? '#89B4FA',
    useCoverArtView: map['UseCoverArtView'] == 1,
    wallpaperPath: map['WallpaperPath'] ?? '',
  );

  LauncherConfig copyWith({
    String? backgroundColor,
    String? sidebarColor,
    String? accentColor,
    bool? useCoverArtView,
    String? wallpaperPath,
    List<AppItem>? apps,
  }) {
    return LauncherConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sidebarColor: sidebarColor ?? this.sidebarColor,
      accentColor: accentColor ?? this.accentColor,
      useCoverArtView: useCoverArtView ?? this.useCoverArtView,
      wallpaperPath: wallpaperPath ?? this.wallpaperPath,
      apps: apps ?? this.apps,
    );
  }
}
