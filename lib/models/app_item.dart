// models/app_item.dart
class AppItem {
  final int? id;
  final String name;
  final String category;
  final String executionPath;
  final String iconPath;
  final String coverArtPath;
  final DateTime? lastModified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppItem({
    this.id,
    required this.name,
    required this.category,
    required this.executionPath,
    this.iconPath = '/Assets/placeholder.png',
    this.coverArtPath = '/Assets/placeholder.png',
    this.lastModified,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'Id': id,
    'Name': name,
    'Category': category,
    'ExecutionPath': executionPath,
    'IconPath': iconPath,
    'CoverArtPath': coverArtPath,
    if (lastModified != null) 'LastModified': lastModified!.toIso8601String(),
    if (createdAt != null) 'CreatedAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'UpdatedAt': updatedAt!.toIso8601String(),
  };

  factory AppItem.fromMap(Map<String, dynamic> map) => AppItem(
    id: map['Id'],
    name: map['Name'],
    category: map['Category'],
    executionPath: map['ExecutionPath'],
    iconPath: map['IconPath'] ?? '/Assets/placeholder.png',
    coverArtPath: map['CoverArtPath'] ?? '/Assets/placeholder.png',
    lastModified: map['LastModified'] != null
        ? DateTime.parse(map['LastModified'])
        : null,
    createdAt: map['CreatedAt'] != null
        ? DateTime.parse(map['CreatedAt'])
        : null,
    updatedAt: map['UpdatedAt'] != null
        ? DateTime.parse(map['UpdatedAt'])
        : null,
  );

  AppItem copyWith({
    int? id,
    String? name,
    String? category,
    String? executionPath,
    String? iconPath,
    String? coverArtPath,
    DateTime? lastModified,
  }) {
    return AppItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      executionPath: executionPath ?? this.executionPath,
      iconPath: iconPath ?? this.iconPath,
      coverArtPath: coverArtPath ?? this.coverArtPath,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
