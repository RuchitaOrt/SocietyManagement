import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import '../bloc/AuditLogBloc/audit_log_bloc.dart';
import '../bloc/AuditLogBloc/audit_log_event.dart';
import '../bloc/AuditLogBloc/audit_log_model.dart';
import '../bloc/AuditLogBloc/audit_log_state.dart';

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  static const pink = Color(0xFFE93691);
  static const navy = Color(0xFF24334D);
  static const pageColor = Color(0xFFF4F7FB);


  Widget _actionBadge(String action) {
    final normalizedAction = action.toLowerCase();

    Color background;
    Color foreground;

    switch (normalizedAction) {
      case 'create':
        background = const Color(0xFFE0F1FF);
        foreground = const Color(0xFF2786E8);
        break;
      case 'update':
        background = const Color(0xFFFFF0C7);
        foreground = const Color(0xFFB98200);
        break;
      case 'delete':
        background = const Color(0xFFFFE3E3);
        foreground = const Color(0xFFE04444);
        break;
      default:
        background = const Color(0xFFF0F2F5);
        foreground = const Color(0xFF64748B);
    }

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
        action.toUpperCase(),
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _auditInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: const Color(0xFF8796AB),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF71819A),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuditCard(
    AuditLogModel log,
    int index,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8EDF4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SERIAL NUMBER + ACTION
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F6),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: pink,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  log.module,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: navy,
                  ),
                ),
              ),
              _actionBadge(log.action),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEAF0F7)),
          const SizedBox(height: 12),

          _auditInfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Date & Time',
            value: log.date,
          ),

          const SizedBox(height: 10),

          _auditInfoRow(
            icon: Icons.person_outline_rounded,
            label: 'User',
            value: log.user,
          ),

          const SizedBox(height: 10),

          _auditInfoRow(
            icon: Icons.grid_view_rounded,
            label: 'Module',
            value: log.module,
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEAF0F7)),
          const SizedBox(height: 10),

          const Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: Color(0xFF8796AB),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 15,
                color: pink,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  log.description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF52627C),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 42,
            color: Color(0xFFB8C7DC),
          ),
          SizedBox(height: 10),
          Text(
            'No Audit Logs Found',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'System activity will appear here.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8796AB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditCards(AuditLogState state) {
    final logs = state.paginatedLogs;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECTION HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFE8F1),
                  Color(0xFFFFEBD8),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: const Text(
              'Audit Log List',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),
          ),

          if (logs.isEmpty)
            _buildEmptyState()
          else
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: List.generate(
                  logs.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildAuditCard(
                      logs[index],
                      (state.currentPage - 1) *
                              AuditLogState.pageSize +
                          index +
                          1,
                    ),
                  ),
                ),
              ),
            ),

          if (state.filteredLogs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                'Showing '
                '${(state.currentPage - 1) * AuditLogState.pageSize + 1}-'
                '${((state.currentPage - 1) * AuditLogState.pageSize +
                        logs.length)} '
                'of ${state.filteredLogs.length}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPagination(AuditLogState state, BuildContext context) {
    if (state.filteredLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _pageButton(
            icon: Icons.chevron_left_rounded,
            enabled: state.currentPage > 1,
            onTap: () {
              context.read<AuditLogBloc>().add(
                    AuditLogPageChanged(state.currentPage - 1),
                  );
            },
          ),
          const SizedBox(width: 6),
          ...List.generate(state.totalPages, (index) {
            final page = index + 1;
            final selected = state.currentPage == page;

            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: InkWell(
                onTap: () {
                  context.read<AuditLogBloc>().add(
                        AuditLogPageChanged(page),
                      );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? pink : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? pink
                          : const Color(0xFFDCE4EF),
                    ),
                  ),
                  child: Text(
                    '$page',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : navy,
                    ),
                  ),
                ),
              ),
            );
          }),
          _pageButton(
            icon: Icons.chevron_right_rounded,
            enabled: state.currentPage < state.totalPages,
            onTap: () {
              context.read<AuditLogBloc>().add(
                    AuditLogPageChanged(state.currentPage + 1),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _pageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 36,
        width: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFDCE4EF),
          ),
        ),
        child: Icon(
          icon,
          size: 19,
          color: enabled
              ? navy
              : const Color(0xFFB8C7DC),
        ),
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    AuditLogState state,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: state.selectedAction,
                isExpanded: true,
                decoration: _filterDecoration('Select action'),
                style: const TextStyle(
                  fontSize: 12,
                  color: navy,
                ),
                items: const [
                  'All actions',
                  'Create',
                  'Update',
                  'Delete',
                ].map((action) {
                  return DropdownMenuItem(
                    value: action,
                    child: Text(action),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<AuditLogBloc>().add(
                          AuditLogActionChanged(value),
                        );
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: TextField(
                onChanged: (value) {
                  context.read<AuditLogBloc>().add(
                        AuditLogModuleQueryChanged(value),
                      );
                },
                onSubmitted: (_) {
                  context.read<AuditLogBloc>().add(
                        AuditLogSearchSubmitted(),
                      );
                },
                decoration: _filterDecoration(
                  'Filter by module',
                ),
                style: const TextStyle(
                  fontSize: 12,
                  color: navy,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuditLogBloc>().add(
                        AuditLogSearchSubmitted(),
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration _filterDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF8796AB),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFDCE4EF),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(
          color: Color(0xFFDCE4EF),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: pink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditLogBloc, AuditLogState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AdminColors.page,
          appBar: AppBar(
            backgroundColor: AdminColors.page,
            elevation: 0,
            titleSpacing: 18,
            title: Column(
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
                    'Audit Log',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Review changes made across the society management system',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
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
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SUMMARY CARDS
               

                  // FILTERS
                  _buildFilters(context, state),

                  const SizedBox(height: 15),

                  // AUDIT LOG CARDS
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildAuditCards(state),
                    ),
                  ),

                  // PAGINATION
                  // _buildPagination(state, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}