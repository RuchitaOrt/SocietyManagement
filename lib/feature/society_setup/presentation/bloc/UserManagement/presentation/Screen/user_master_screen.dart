
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart' show AdminColors;
import 'package:society_management/feature/society_setup/presentation/widgets/UserManagement/AddUserBottomSheet.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_model.dart';
import '../bloc/user_state.dart';


const Color userPrimary = Color(0xFFE93691);
const Color userBackground = Color(0xFFF4F6FA);
const Color userText = Color(0xFF25324A);
const Color userMuted = Color(0xFF71829F);
const Color userGreen = Color(0xFF10B981);
const Color userRed = Color(0xFFFF4545);

class UserMasterScreen extends StatelessWidget {
  const UserMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(),
      child: const _UserMasterView(),
    );
  }
}

class _UserMasterView extends StatefulWidget {
  const _UserMasterView();

  @override
  State<_UserMasterView> createState() =>
      _UserMasterViewState();
}

class _UserMasterViewState extends State<_UserMasterView> {
  final TextEditingController _searchController =
      TextEditingController();

  final List<String> roles = [
    'Admin',
    'Society Manager',
    'Committee Member',
    'Security',
    'Resident',
  ];

  final List<String> societies = [
    'Jainam',
    'Green Valley',
    'Sunshine Heights',
  ];

  Future<void> _addUser() async {
    await showAddUserBottomSheet(
      context: context,
      roles: roles,
      initialSociety: 'Jainam',
      onSubmit: (userData) {
        context.read<UserBloc>().add(
          AddUserEvent(userData),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AdminColors.page,
       floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: _addUser,
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add User',
        style: TextStyle(color: Colors.white),
      ),
    ),
    
  ],
),
     appBar: AppBar(
  title: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            Color(0xFFEC4899),
            Color(0xFFF97316),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        child: const Text(
         'User Master',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
        
 
      const SizedBox(height: 3),
      Text(
        'Manage all your users in one place',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  ),
 
  backgroundColor: AdminColors.page,
  elevation: 0,
  actions: [
    IconButton(
      onPressed: () {
        // TODO: Navigate to Notifications Screen
      },
      icon: const Icon(
        Icons.notifications_none_rounded,
        color: Color(0xFFEC4899),
        size: 25,
      ),
      tooltip: 'Notifications',
    ),
    const SizedBox(width: 6),
  ],
),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 850;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 28 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(isWide),
                  const SizedBox(height: 22),
               BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    return _buildStats(state);
  },
),
                  const SizedBox(height: 18),
                  _buildUserList(isWide),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWide)
          Row(
            children: [
              // Expanded(child: _heading()),
              const SizedBox(width: 20),
              SizedBox(
                width: 320,
                child: _searchField(),
              ),
              const SizedBox(width: 12),
              // _addButton(),
            ],
          )
        else ...[
          // _heading(),
          // const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _searchField()),
              const SizedBox(width: 10),
              // _addButton(),
            ],
          ),
        ],
      ],
    );
  }

  Widget _heading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(
            colors: [
              Color(0xFFEC4899),
              Color(0xFFF97316),
            ],
          ).createShader(bounds),
          child: const Text(
            'User Master',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Manage all your users in one place',
          style: TextStyle(
            fontSize: 12,
            color: userMuted,
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return SizedBox(
      height: 42,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<UserBloc>().add(
            SearchUserEvent(value),
          );
        },
        style: const TextStyle(
          fontSize: 12,
          color: userText,
        ),
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFFB5C0D1),
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 19,
            color: Color(0xFFB5C0D1),
          ),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFDCE3EF),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: userPrimary,
            ),
          ),
        ),
      ),
    );
  }

Widget _buildStats(UserState state) {
  final cards = [
    _UserStat(
      'Total Users',
      state.totalUsers,
      Icons.people_outline,
      Colors.blue,
    ),
    _UserStat(
      'Active',
      state.activeUsers,
      Icons.check_circle_outline,
      Colors.green,
    ),
    _UserStat(
      'Inactive',
      state.inactiveUsers,
      Icons.cancel_outlined,
      Colors.orange,
    ),
  ];

  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final item = cards[index];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade100,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.count}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

  Widget _buildUserList(bool isWide) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final users = state.filteredUsers;

        if (users.isEmpty) {
          return _emptyState(
            state.searchQuery.isNotEmpty,
          );
        }

        if (!isWide) {
          return Column(
            children: users.map((user) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _mobileUserCard(user),
              );
            }).toList(),
          );
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFEDF0F5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.035),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 54,
                dataRowMaxHeight: 58,
                horizontalMargin: 14,
                columnSpacing: 22,
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFFFFE9E0),
                ),
                columns: const [
                  DataColumn(label: _TableHeading('Sr. No.')),
                  DataColumn(label: _TableHeading('Username')),
                  DataColumn(label: _TableHeading('Role')),
                  DataColumn(label: _TableHeading('Society')),
                  DataColumn(label: _TableHeading('Email')),
                  DataColumn(label: _TableHeading('Contact')),
                  DataColumn(label: _TableHeading('Status')),
                  DataColumn(label: _TableHeading('Created')),
                  DataColumn(label: _TableHeading('Actions')),
                ],
                rows: List.generate(users.length, (index) {
                  final user = users[index];

                  return DataRow(
                    cells: [
                      DataCell(_tableText('${index + 1}')),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: userPrimary,
                              size: 17,
                            ),
                            const SizedBox(width: 7),
                            _tableText(user.username, bold: true),
                          ],
                        ),
                      ),
                      DataCell(_roleBadge(user.role)),
                      DataCell(_societyBadge(user.society)),
                      DataCell(_tableText(user.email)),
                      DataCell(_tableText(user.contact)),
                      DataCell(_statusBadge(user.isActive)),
                      DataCell(
                        _tableText(
                          '${user.createdAt.day} '
                          '${_month(user.createdAt.month)} '
                          '${user.createdAt.year}',
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconAction(
                              Icons.edit_outlined,
                              'Edit',
                              () => _showEditMessage(),
                            ),
                            const SizedBox(width: 5),
                            _iconAction(
                              Icons.swap_horiz_rounded,
                              user.isActive
                                  ? 'Deactivate'
                                  : 'Activate',
                              () => _toggleStatus(user),
                            ),
                            const SizedBox(width: 5),
                            _iconAction(
                              Icons.delete_outline,
                              'Delete',
                              () => _deleteUser(user),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mobileUserCard(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9EDF3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFFEAF4),
                child: const Icon(
                  Icons.person_outline,
                  color: userPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        color: userText,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: userMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(user.isActive),
            ],
          ),
          const Divider(height: 22),
          _mobileDetail('Role', user.role),
          _mobileDetail('Society', user.society),
          _mobileDetail('Contact', user.contact),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _iconAction(
                Icons.edit_outlined,
                'Edit',
                _showEditMessage,
              ),
              _iconAction(
                Icons.swap_horiz_rounded,
                'Change Status',
                () => _toggleStatus(user),
              ),
              _iconAction(
                Icons.delete_outline,
                'Delete',
                () => _deleteUser(user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: userMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: userText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(bool isSearching) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFEDF0F5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(17),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEAF4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline,
              size: 35,
              color: userPrimary,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            isSearching ? 'No Users Found' : 'No Users Added Yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: userText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'User details will appear here.',
            style: TextStyle(
              fontSize: 12,
              color: userMuted,
            ),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 15),
            // ElevatedButton.icon(
            //   onPressed: _addUser,
            //   icon: const Icon(Icons.add, size: 17),
            //   label: const Text('Add User'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: userPrimary,
            //     foregroundColor: Colors.white,
            //     elevation: 0,
            //   ),
            // ),
          ],
        ],
      ),
    );
  }

  Widget _tableText(String value, {bool bold = false}) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 11,
        color: userText,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      ),
    );
  }

  Widget _roleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFCCCC),
        ),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFFDC2626),
        ),
      ),
    );
  }

  Widget _societyBadge(String society) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        society,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF2563EB),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    final color = isActive ? userGreen : userRed;
    final background = isActive
        ? const Color(0xFFDCFCEB)
        : const Color(0xFFFFE5E5);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _iconAction(
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFDCE3EF),
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 15,
            color: userMuted,
          ),
        ),
      ),
    );
  }

  Future<void> _toggleStatus(UserModel user) async {
    context.read<UserBloc>().add(
      ToggleUserStatusEvent(user.id),
    );
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user.username}?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: userRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<UserBloc>().add(
        DeleteUserEvent(user.id),
      );
    }
  }

  void _showEditMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Edit form integration is the next step.',
        ),
      ),
    );
  }

  String _month(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}

class _UserStat {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _UserStat(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}
class _TableHeading extends StatelessWidget {
  final String title;

  const _TableHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: userText,
      ),
    );
  }
}
