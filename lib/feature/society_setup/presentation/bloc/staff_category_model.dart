class StaffCategoryModel {
  final String id;
  final String name;
  final String description;

  const StaffCategoryModel({
    required this.id,
    required this.name,
    this.description = '',
  });

  StaffCategoryModel copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return StaffCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };

  factory StaffCategoryModel.fromJson(Map<String, dynamic> json) {
    return StaffCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );
  }
}