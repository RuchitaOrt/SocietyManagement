class AuthUser {
  const AuthUser({
    required this.token,
    this.name,
  });

  final String token;
  final String? name;
}
