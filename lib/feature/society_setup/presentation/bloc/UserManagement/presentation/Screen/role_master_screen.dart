
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/Role/add_role_dialog.dart';

import '../bloc/Role/role_bloc.dart';
import '../bloc/Role/role_event.dart';
import '../bloc/Role/role_model.dart';
import '../bloc/Role/role_state.dart';


const Color rolePageBg = Color(0xFFF4F6FA);
const Color rolePink = Color(0xFFE93691);
const Color roleDark = Color(0xFF25324A);
const Color roleGrey = Color(0xFF71829F);
const Color roleGreen = Color(0xFF10B981);
const Color roleRed = Color(0xFFFF4545);

class RoleMasterScreen extends StatelessWidget {
  const RoleMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoleBloc(),
      child: const _RoleMasterView(),
    );
  }
}

class _RoleMasterView extends StatefulWidget {
  const _RoleMasterView();

  @override
  State<_RoleMasterView> createState() =>
      _RoleMasterViewState();
}

class _RoleMasterViewState extends State<_RoleMasterView> {
  final TextEditingController _searchController =
      TextEditingController();

  final String societyName = 'Jainam';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addRole() async {
    await showAddRoleDialog(
      context: context,
      initialSociety: societyName,
      onSubmit: (roleName, society) {
        final bloc = context.read<RoleBloc>();

        final exists = bloc.state.roles.any(
          (role) =>
              role.roleName.toLowerCase() ==
                  roleName.toLowerCase() &&
              role.society.toLowerCase() ==
                  society.toLowerCase(),
        );

        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This role already exists.'),
            ),
          );
          return;
        }

        bloc.add(
          AddRoleEvent(
            roleName: roleName,
            society: society,
          ),
        );
      },
    );
  }

  Future<void> _editRole(RoleModel role) async {
    await showAddRoleDialog(
      context: context,
      initialSociety: role.society,
      initialRoleName: role.roleName,
      onSubmit: (roleName, society) {
        final duplicate = context.read<RoleBloc>().state.roles.any(
          (item) =>
              item.id != role.id &&
              item.roleName.toLowerCase() ==
                  roleName.toLowerCase() &&
              item.society.toLowerCase() ==
                  society.toLowerCase(),
        );

        if (duplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This role already exists.'),
            ),
          );
          return;
        }

        context.read<RoleBloc>().add(
          UpdateRoleEvent(
            role.copyWith(
              roleName: roleName,
              society: society,
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteRole(RoleModel role) async {
    if (role.isSystemRole) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete Role'),
          content: Text(
            'Are you sure you want to delete "${role.roleName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: roleRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      context.read<RoleBloc>().add(
        DeleteRoleEvent(role.id),
      );
    }
  }

  void _toggleStatus(RoleModel role) {
    if (role.isSystemRole) return;

    context.read<RoleBloc>().add(
      ToggleRoleStatusEvent(role.id),
    );
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
      onPressed: _addRole,
      backgroundColor: const Color(0xFFE93691),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add Role',
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
         'Role Master',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
        
 
      const SizedBox(height: 3),
      Text(
        'Manage all user roles',
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
                  _buildHeader(isWide),
                  const SizedBox(height: 22),

                  BlocBuilder<RoleBloc, RoleState>(
                    builder: (context, state) {
                      return _buildSummaryCards(
                        state,
                        isWide,
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  BlocBuilder<RoleBloc, RoleState>(
                    builder: (context, state) {
                      return _buildRoleTable(
                        state,
                        isWide,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isWide)
          Row(
            children: [
              // Expanded(
              //   child: _heading(),
              // ),
              // const SizedBox(width: 20),
              SizedBox(
                width: 320,
                child: _searchField(),
              ),
              const SizedBox(width: 10),
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
            'Role Master',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Manage all user roles',
          style: TextStyle(
            fontSize: 12,
            color: roleGrey,
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
          context.read<RoleBloc>().add(
            SearchRoleEvent(value),
          );
        },
        style: const TextStyle(
          fontSize: 12,
          color: roleDark,
        ),
        decoration: InputDecoration(
          hintText: 'Search role name...',
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
              color: rolePink,
            ),
          ),
        ),
      ),
    );
  }

  // Widget _addButton() {
  //   return SizedBox(
  //     height: 42,
  //     child: ElevatedButton.icon(
  //       onPressed: _addRole,
  //       icon: const Icon(Icons.add, size: 18),
  //       label: const Text(
  //         'Add Role',
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: rolePink,
  //         foregroundColor: Colors.white,
  //         elevation: 0,
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(9),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSummaryCards(
    RoleState state,
    bool isWide,
  ) {
    final cards = [
      _RoleSummaryData(
        'Total Roles',
        state.totalRoles,
        Icons.description_outlined,
        rolePink,
      ),
      _RoleSummaryData(
        'Active',
        state.activeRoles,
        Icons.check_circle_outline,
        rolePink,
      ),
      _RoleSummaryData(
        'Inactive',
        state.inactiveRoles,
        Icons.cancel_outlined,
        Colors.orange,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 650 ? 3 : 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
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
                              color: roleDark,
                            ),
                          ),
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: roleGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRoleTable(
    RoleState state,
    bool isWide,
  ) {
    final roles = state.filteredRoles;

    if (roles.isEmpty) {
      return _emptyState(state.searchQuery.isNotEmpty);
    }

    if (!isWide) {
      return Column(
        children: roles.map((role) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _mobileRoleCard(role),
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
            dataRowMinHeight: 38,
            dataRowMaxHeight: 40,
            horizontalMargin: 14,
            columnSpacing: 24,
            headingRowColor: WidgetStateProperty.all(
              const Color(0xFFFFE9E0),
            ),
            columns: const [
              DataColumn(label: _RoleTableHeading('Sr. No.')),
              DataColumn(label: _RoleTableHeading('Role Name')),
              DataColumn(label: _RoleTableHeading('Society')),
              DataColumn(label: _RoleTableHeading('Status')),
              DataColumn(label: _RoleTableHeading('Created')),
              DataColumn(label: _RoleTableHeading('Actions')),
            ],
            rows: List.generate(roles.length, (index) {
              final role = roles[index];

              return DataRow(
                cells: [
                  DataCell(_tableText('${index + 1}')),
                  DataCell(
                    _tableText(role.roleName, bold: true),
                  ),
                  DataCell(
                    role.society.isEmpty
                        ? _tableText('—')
                        : _societyBadge(role.society),
                  ),
                  DataCell(_statusBadge(role.isActive)),
                  DataCell(
                    _tableText(
                      '${role.createdAt.day} '
                      '${_month(role.createdAt.month)} '
                      '${role.createdAt.year}',
                    ),
                  ),
                  DataCell(
                    role.isSystemRole
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _iconAction(
                                Icons.edit_outlined,
                                'Edit',
                                () => _editRole(role),
                              ),
                              const SizedBox(width: 5),
                              _iconAction(
                                Icons.swap_horiz_rounded,
                                'Change Status',
                                () => _toggleStatus(role),
                              ),
                              const SizedBox(width: 5),
                              _iconAction(
                                Icons.delete_outline,
                                'Delete',
                                () => _deleteRole(role),
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
  }

  Widget _mobileRoleCard(RoleModel role) {
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
              Expanded(
                child: Text(
                  role.roleName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: roleDark,
                  ),
                ),
              ),
              _statusBadge(role.isActive),
            ],
          ),
          const Divider(height: 22),
          _mobileDetail('Society', role.society),
          _mobileDetail(
            'Created',
            '${role.createdAt.day} '
            '${_month(role.createdAt.month)} '
            '${role.createdAt.year}',
          ),
          if (!role.isSystemRole) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _iconAction(
                  Icons.edit_outlined,
                  'Edit',
                  () => _editRole(role),
                ),
                _iconAction(
                  Icons.swap_horiz_rounded,
                  'Change Status',
                  () => _toggleStatus(role),
                ),
                _iconAction(
                  Icons.delete_outline,
                  'Delete',
                  () => _deleteRole(role),
                ),
              ],
            ),
          ],
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
                color: roleGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: roleDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(bool searching) {
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
          const Icon(
            Icons.description_outlined,
            size: 40,
            color: rolePink,
          ),
          const SizedBox(height: 12),
          Text(
            searching ? 'No Roles Found' : 'No Roles Added Yet',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: roleDark,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Role details will appear here.',
            style: TextStyle(
              fontSize: 12,
              color: roleGrey,
            ),
          ),
          // if (!searching) ...[
          //   const SizedBox(height: 15),
          //   ElevatedButton.icon(
          //     onPressed: _addRole,
          //     icon: const Icon(Icons.add, size: 17),
          //     label: const Text('Add Role'),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: rolePink,
          //       foregroundColor: Colors.white,
          //       elevation: 0,
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  Widget _tableText(String value, {bool bold = false}) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 11,
        color: roleDark,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
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

  Widget _statusBadge(bool active) {
    final color = active ? roleGreen : roleRed;
    final background = active
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
        active ? 'ACTIVE' : 'INACTIVE',
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
            color: roleGrey,
          ),
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

class _RoleSummaryData {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _RoleSummaryData(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}

class _RoleTableHeading extends StatelessWidget {
  final String title;

  const _RoleTableHeading(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: roleDark,
      ),
    );
  }
}
