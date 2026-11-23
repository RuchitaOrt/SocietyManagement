
import 'role_model.dart';

class RoleState {
  final List<RoleModel> roles;
  final String searchQuery;

  const RoleState({
    this.roles = const [],
    this.searchQuery = '',
  });

  int get totalRoles => roles.length;

  int get activeRoles =>
      roles.where((role) => role.isActive).length;

  int get inactiveRoles =>
      roles.where((role) => !role.isActive).length;

  List<RoleModel> get filteredRoles {
    if (searchQuery.trim().isEmpty) {
      return roles;
    }

    final query = searchQuery.toLowerCase().trim();

    return roles.where((role) {
      return role.roleName.toLowerCase().contains(query) ||
          role.society.toLowerCase().contains(query);
    }).toList();
  }

  RoleState copyWith({
    List<RoleModel>? roles,
    String? searchQuery,
  }) {
    return RoleState(
      roles: roles ?? this.roles,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
