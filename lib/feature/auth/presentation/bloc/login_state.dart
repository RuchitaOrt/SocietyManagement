import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.token,
    this.userName,
  });

  final LoginStatus status;
  final String? errorMessage;
  final String? token;
  final String? userName;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    String? token,
    String? userName,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      token: token ?? this.token,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, token, userName];
}
