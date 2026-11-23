
class RoleModel {
  final String id;
  final String roleName;
  final String society;
  final bool isActive;
  final DateTime createdAt;
  final bool isSystemRole;

  RoleModel({
    required this.id,
    required this.roleName,
    required this.society,
    this.isActive = true,
    DateTime? createdAt,
    this.isSystemRole = false,
  }) : createdAt = createdAt ?? DateTime.now();

  RoleModel copyWith({
    String? roleName,
    String? society,
    bool? isActive,
  }) {
    return RoleModel(
      id: id,
      roleName: roleName ?? this.roleName,
      society: society ?? this.society,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      isSystemRole: isSystemRole,
    );
  }
}
