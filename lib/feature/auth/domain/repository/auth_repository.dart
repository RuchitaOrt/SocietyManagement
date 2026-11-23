import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  });
}
