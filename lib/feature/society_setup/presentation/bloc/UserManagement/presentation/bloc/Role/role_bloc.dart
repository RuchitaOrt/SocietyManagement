
import 'package:flutter_bloc/flutter_bloc.dart';

import 'role_event.dart';
import 'role_model.dart';
import 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  RoleBloc() : super(const RoleState()) {

    on<AddRoleEvent>((event, emit) {
      final exists = state.roles.any(
        (role) =>
            role.roleName.toLowerCase().trim() ==
                event.roleName.toLowerCase().trim() &&
            role.society.toLowerCase().trim() ==
                event.society.toLowerCase().trim(),
      );

      if (exists) return;

      final role = RoleModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        roleName: event.roleName.trim(),
        society: event.society.trim(),
      );

      emit(
        state.copyWith(
          roles: [...state.roles, role],
        ),
      );
    });

    on<SearchRoleEvent>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });

    on<ToggleRoleStatusEvent>((event, emit) {
      final updatedRoles = state.roles.map((role) {
        if (role.id == event.roleId && !role.isSystemRole) {
          return role.copyWith(isActive: !role.isActive);
        }
        return role;
      }).toList();

      emit(state.copyWith(roles: updatedRoles));
    });

    on<DeleteRoleEvent>((event, emit) {
      final updatedRoles = state.roles
          .where(
            (role) =>
                role.id != event.roleId || role.isSystemRole,
          )
          .toList();

      emit(state.copyWith(roles: updatedRoles));
    });

    on<UpdateRoleEvent>((event, emit) {
      final duplicate = state.roles.any(
        (role) =>
            role.id != event.role.id &&
            role.roleName.toLowerCase().trim() ==
                event.role.roleName.toLowerCase().trim() &&
            role.society.toLowerCase().trim() ==
                event.role.society.toLowerCase().trim(),
      );

      if (duplicate) return;

      final updatedRoles = state.roles.map((role) {
        return role.id == event.role.id ? event.role : role;
      }).toList();

      emit(state.copyWith(roles: updatedRoles));
    });
  }
}
