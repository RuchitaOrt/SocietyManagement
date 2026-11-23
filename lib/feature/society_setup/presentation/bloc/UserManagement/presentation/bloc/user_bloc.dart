import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_model.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {

    on<AddUserEvent>((event, emit) {
      final user = UserModel.fromMap(event.userData);

      emit(
        state.copyWith(
          users: [...state.users, user],
        ),
      );
    });

    on<SearchUserEvent>((event, emit) {
      emit(
        state.copyWith(
          searchQuery: event.query,
        ),
      );
    });

    on<ToggleUserStatusEvent>((event, emit) {
      final updatedUsers = state.users.map((user) {
        if (user.id == event.userId) {
          return user.copyWith(
            isActive: !user.isActive,
          );
        }
        return user;
      }).toList();

      emit(state.copyWith(users: updatedUsers));
    });

    on<DeleteUserEvent>((event, emit) {
      final updatedUsers = state.users
          .where((user) => user.id != event.userId)
          .toList();

      emit(state.copyWith(users: updatedUsers));
    });

    on<UpdateUserEvent>((event, emit) {
      final updatedUsers = state.users.map((user) {
        return user.id == event.user.id
            ? event.user
            : user;
      }).toList();

      emit(state.copyWith(users: updatedUsers));
    });
  }
}