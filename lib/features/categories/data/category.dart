enum CategoryType { income, expense }

class Category {
  final int id;
  final String name;
  final CategoryType type;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    for (final field in ['name', 'type', 'createdAt', 'updatedAt']) {
      if (json[field] is! String) {
        throw FormatException(
          'Category.$field must be a string (missing, null, or wrong type).',
        );
      }
    }

    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      type: CategoryType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
