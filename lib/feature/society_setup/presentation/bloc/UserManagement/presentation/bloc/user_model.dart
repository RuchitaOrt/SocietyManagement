class UserModel {
  final String id;
  final String username;
  final String email;
  final String contact;
  final String society;
  final String role;
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.contact,
    required this.society,
    required this.role,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  UserModel copyWith({
    String? username,
    String? email,
    String? contact,
    String? society,
    String? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      contact: contact ?? this.contact,
      society: society ?? this.society,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromMap(Map<String, String> data) {
    return UserModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      contact: data['contact'] ?? '',
      society: data['society'] ?? '',
      role: data['role'] ?? '',
    );
  }
}