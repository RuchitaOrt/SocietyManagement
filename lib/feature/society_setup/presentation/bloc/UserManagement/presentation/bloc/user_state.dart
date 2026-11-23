import 'user_model.dart';

class UserState {
  final List<UserModel> users;
  final String searchQuery;

  const UserState({
    this.users = const [],
    this.searchQuery = '',
  });

  int get totalUsers => users.length;

  int get activeUsers =>
      users.where((user) => user.isActive).length;

  int get inactiveUsers =>
      users.where((user) => !user.isActive).length;

  List<UserModel> get filteredUsers {
    if (searchQuery.trim().isEmpty) {
      return users;
    }

    final query = searchQuery.toLowerCase().trim();

    return users.where((user) {
      return user.username.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.contact.contains(query) ||
          user.role.toLowerCase().contains(query) ||
          user.society.toLowerCase().contains(query);
    }).toList();
  }

  UserState copyWith({
    List<UserModel>? users,
    String? searchQuery,
  }) {
    return UserState(
      users: users ?? this.users,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}