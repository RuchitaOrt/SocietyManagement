
import 'role_model.dart';

abstract class RoleEvent {}

class AddRoleEvent extends RoleEvent {
  final String roleName;
  final String society;

  AddRoleEvent({
    required this.roleName,
    required this.society,
  });
}

class SearchRoleEvent extends RoleEvent {
  final String query;

  SearchRoleEvent(this.query);
}

class ToggleRoleStatusEvent extends RoleEvent {
  final String roleId;

  ToggleRoleStatusEvent(this.roleId);
}

class DeleteRoleEvent extends RoleEvent {
  final String roleId;

  DeleteRoleEvent(this.roleId);
}

class UpdateRoleEvent extends RoleEvent {
  final RoleModel role;

  UpdateRoleEvent(this.role);
}
