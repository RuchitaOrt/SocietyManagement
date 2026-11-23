import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.emailOrPhone,
    required this.password,
  });

  final String emailOrPhone;
  final String password;

  @override
  List<Object?> get props => [emailOrPhone, password];
}

final class LoginReset extends LoginEvent {
  const LoginReset();
}
