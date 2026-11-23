import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>((event, emit) {
      emit(const LoginState());
    });
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      status: LoginStatus.loading,
      clearError: true,
    ));

    // Temporary dummy response for UI testing.
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(
      status: LoginStatus.success,
      token: 'dummy-token',
      userName: 'Demo User',
    ));
  }
}