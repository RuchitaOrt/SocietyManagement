
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/SoceityStaff/society_staff_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/SoceityStaff/staff_category_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_model.dart';
import 'package:society_management/feature/society_setup/presentation/pages/complaint_management_screen.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/Staff/add_staff_bottom_sheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/Staff/add_staff_category_bottom_sheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/VisitorManagement/add_visitor_pass_bottom_sheet.dart';


const Color staffPrimary = Color(0xFFE93691);
const Color staffBackground = Color(0xFFF4F6FA);
const Color staffText = Color(0xFF25324A);
const Color staffMuted = Color(0xFF71829F);
const Color staffGreen = Color(0xFF10B981);
const Color staffRed = Color(0xFFFF4545);
class SocietyStaffScreen extends StatelessWidget {
  final Future<StaffModel?> Function(BuildContext, StaffModel)? onEditStaff;

  const SocietyStaffScreen({
    super.key,
    this.onEditStaff,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocietyStaffBloc>(
          create: (_) => SocietyStaffBloc(),
        ),
        BlocProvider<StaffCategoryBloc>(
          create: (_) => StaffCategoryBloc(),
        ),
      ],
      child: _SocietyStaffView(
        onEditStaff: onEditStaff,
      ),
    );
  }
}
class _SocietyStaffView extends StatefulWidget {
  final Future<StaffModel?> Function(BuildContext, StaffModel)? onEditStaff;

  const _SocietyStaffView({
    this.onEditStaff,
  });

  @override
  State<_SocietyStaffView> createState() => _SocietyStaffViewState();
}

class _SocietyStaffViewState extends State<_SocietyStaffView> {
  
Future<void> _addStaff() async {
  final staff = await showAddStaffBottomSheet(
    context: context,
  );

  if (!mounted || staff == null) return;

  context.read<SocietyStaffBloc>().add(
    AddStaffEvent(staff),
  );
}
Future<void> _addCategory() async {
  await showAddStaffCategoryBottomSheet(
    context: context,
  );

  if (!mounted) return;


  // Next: Save category using StaffCategoryBloc.
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: AdminColors.page,
        floatingActionButton: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton.extended(
      heroTag: 'addCategory',
      onPressed: _addCategory,
      backgroundColor: const Color(0xFFF97316),
      icon: const Icon(Icons.category_outlined, color: Colors.white),
      label: const Text(
        'Add Category',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const SizedBox(width: 10),
    FloatingActionButton.extended(
      heroTag: 'addStaff',
      onPressed: _addStaff,
      backgroundColor: staffPrimary,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Add Staff',
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
         'Society Staff',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
        
 
      const SizedBox(height: 3),
      Text(
        'Manage staff and daily attendance',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildHeader(context),
              // const SizedBox(height: 22),
              _buildStats(),
              const SizedBox(height: 18),
              _buildFilters(),
              const SizedBox(height: 18),
              Expanded(
                child: BlocBuilder<SocietyStaffBloc, SocietyStaffState>(
                  builder: (context, state) {
                    final staff = state.filteredStaff;

                    if (staff.isEmpty) {
                      return _emptyState(context, state);
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 900;

                        if (isWide) {
                          return GridView.builder(
                            itemCount: staff.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 380,
                              mainAxisExtent: 160,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              return _StaffCard(
                                staff: staff[index],
                                onEditStaff: widget.onEditStaff,
                              );
                            },
                          );
                        }

                        return ListView.separated(
                          itemCount: staff.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            return _StaffCard(
                              staff: staff[index],
                              onEditStaff: widget.onEditStaff,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildHeader(BuildContext context) {
Widget _buildStats() {
  return BlocBuilder<SocietyStaffBloc, SocietyStaffState>(
    builder: (context, state) {
      final cards = [
        _StaffSummaryItem(
          'Total Staff',
          state.totalStaff,
          Icons.groups_2_outlined,
          staffPrimary,
        ),
        _StaffSummaryItem(
          'Present Today',
          state.presentCount,
          Icons.check_circle_outline,
          Colors.green,
        ),
        _StaffSummaryItem(
          'Absent Today',
          state.absentCount,
          Icons.cancel_outlined,
          Colors.red,
        ),
      ];

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: SizedBox(
          height: 160,
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
        ),
      );
    },
  );
}

  Widget _buildFilters() {
    return BlocBuilder<SocietyStaffBloc, SocietyStaffState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _filterButton(
                  context,
                  'All Staff',
                  StaffFilter.all,
                  state.filter,
                  state.totalStaff,
                ),
                _filterButton(
                  context,
                  'Present',
                  StaffFilter.present,
                  state.filter,
                  state.presentCount,
                  dotColor: staffGreen,
                ),
                _filterButton(
                  context,
                  'Absent',
                  StaffFilter.absent,
                  state.filter,
                  state.absentCount,
                  dotColor: staffRed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterButton(
    BuildContext context,
    String title,
    StaffFilter filter,
    StaffFilter selected,
    int count, {
    Color? dotColor,
  }) {
    final isSelected = filter == selected;

    return GestureDetector(
      onTap: () {
        context.read<SocietyStaffBloc>().add(ChangeStaffFilterEvent(filter));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? staffPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (dotColor != null && !isSelected) ...[
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : staffMuted,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 9),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(.22)
                    : const Color(0xFFE8EDF4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : staffMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _emptyState(BuildContext context, SocietyStaffState state) {
  return Center(
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEAF4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.groups_2_outlined,
              size: 40,
              color: staffPrimary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Staff Found',
            style: TextStyle(
              color: staffText,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Staff details will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: staffMuted),
          ),
        ],
      ),
    ),
  );
}
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: staffText,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: staffMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffModel staff;
  final Future<StaffModel?> Function(BuildContext, StaffModel)? onEditStaff;

  const _StaffCard({
    required this.staff,
    this.onEditStaff,
  });

@override
Widget build(BuildContext context) {
  return BlocBuilder<SocietyStaffBloc, SocietyStaffState>(
    builder: (context, state) {
     final isPresent =
    state.attendance[staff.mobileNumber] == true;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE9EDF3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Staff details
            Row(
              children: [
                _photo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        staff.mobileNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(isPresent),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEDF0F5)),
            const SizedBox(height: 12),

            // Attendance and actions
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _attendanceButton(context, isPresent),
                _actionButton(
                  icon: Icons.history_rounded,
                  label: 'History',
                  onTap: () {
                    // Add attendance history navigation here.
                  },
                ),
                _actionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () async {
                    // Add your existing edit logic here.
                  },
                ),
                _actionButton(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  onTap: () => _deleteStaff(context),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

  Widget _photo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAF4),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: staff.staffPhotoPath != null &&
              staff.staffPhotoPath!.isNotEmpty
          ? Image.file(
              File(staff.staffPhotoPath!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _photoPlaceholder(),
            )
          : _photoPlaceholder(),
    );
  }

  Widget _photoPlaceholder() {
    return const Icon(
      Icons.person_outline,
      color: staffPrimary,
      size: 28,
    );
  }

  Widget _statusBadge(bool isPresent) {
    final color = isPresent ? staffGreen : staffRed;
    final background =
        isPresent ? const Color(0xFFE0FBEA) : const Color(0xFFFFE5E5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPresent ? 'PRESENT' : 'ABSENT',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _attendanceButton(BuildContext context, bool isPresent) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<SocietyStaffBloc>().add(
                ToggleStaffAttendanceEvent(staff.mobileNumber),
              );
        },
        icon: Icon(
          isPresent ? Icons.logout : Icons.login,
          size: 15,
        ),
        label: Text(
          isPresent ? 'Check Out' : 'Check In',
          overflow: TextOverflow.ellipsis,
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isPresent
              ? const Color(0xFFFFF1F1)
              : const Color(0xFFE0FBEA),
          foregroundColor: isPresent ? staffRed : const Color(0xFF15803D),
          side: BorderSide(
            color: isPresent
                ? const Color(0xFFFFCCCC)
                : const Color(0xFFB1EFC9),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }

Widget _actionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Tooltip(
    message: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 34,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE1E8F0),
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: staffMuted, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: staffMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Future<void> _deleteStaff(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Delete Staff'),
        content: Text(
          'Are you sure you want to delete ${staff.fullName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: staffRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      context.read<SocietyStaffBloc>().add(
            DeleteStaffEvent(staff.mobileNumber),
          );
    }
  }
}
class _StaffSummaryItem {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StaffSummaryItem(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}