import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_model.dart';

abstract class UserEvent {}

class AddUserEvent extends UserEvent {
  final Map<String, String> userData;

  AddUserEvent(this.userData);
}

class SearchUserEvent extends UserEvent {
  final String query;

  SearchUserEvent(this.query);
}

class ToggleUserStatusEvent extends UserEvent {
  final String userId;

  ToggleUserStatusEvent(this.userId);
}

class DeleteUserEvent extends UserEvent {
  final String userId;

  DeleteUserEvent(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final UserModel user;

  UpdateUserEvent(this.user);
}