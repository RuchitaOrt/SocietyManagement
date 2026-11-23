
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_event.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/VisitorManagement/visitor_state.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/VisitorManagement/add_visitor_pass_bottom_sheet.dart';

const Color primaryColor = Color(0xFFE93691);
const Color pageColor = Color(0xFFF5F7FA);

class VisitorManagementScreen extends StatefulWidget {
  const VisitorManagementScreen({super.key});

  @override
  State<VisitorManagementScreen> createState() =>
      _VisitorManagementScreenState();
}

class _VisitorManagementScreenState
    extends State<VisitorManagementScreen> {
  final TextEditingController _searchController =
      TextEditingController();
bool _showFilters = false;
  String _selectedStatus = 'All';
  String _selectedType = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddVisitor() async {
    final visitor = await showAddVisitorPassBottomSheet(
      context: context,
      societyName: 'Jainam Bhandup',
    );

    if (!mounted || visitor == null) return;

    context.read<VisitorBloc>().add(
      VisitorPassCreated(visitor),
    );
  }

  List<VisitorPassModel> _filterVisitors(
    List<VisitorPassModel> visitors,
  ) {
    final query = _searchController.text.trim().toLowerCase();

    return visitors.where((visitor) {
      final name = visitor.visitorName.toLowerCase();
      final mobile = visitor.mobileNumber.toLowerCase();

      final matchesSearch =
          name.contains(query) || mobile.contains(query);

      final matchesStatus = _selectedStatus == 'All' ||
          visitor.status.toLowerCase() ==
              _selectedStatus.toLowerCase();

      final matchesType = _selectedType == 'All' ||
          visitor.type.toLowerCase() ==
              _selectedType.toLowerCase();

      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  void _updateStatus(
    VisitorPassModel visitor,
    String status,
  ) {
    context.read<VisitorBloc>().add(
      VisitorPassStatusChanged(visitor, status),
    );
  }

  Future<void> _deleteVisitor(VisitorPassModel visitor) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Visitor?'),
        content: Text(
          'Are you sure you want to delete ${visitor.visitorName}?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      context.read<VisitorBloc>().add(
        VisitorPassDeleted(visitor),
      );
    }
  }

  void _openEditVisitor(VisitorPassModel visitor) {
    // Connect this to the edit-enabled visitor bottom sheet.
    // The bottom sheet should accept the existing visitor
    // and return the updated VisitorPassModel.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.page,
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
          'Visitor Management',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 3),
      Text(
        'Manage visitor pre-approvals, OTP entry and gate history',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddVisitor,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Visitor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<VisitorBloc, VisitorState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            if (state.errorMessage != null) {
              return Center(
                child: Text(state.errorMessage!),
              );
            }

            final visitors = _filterVisitors(state.visitors);

            return Column(
              children: [
                _buildSummaryCards(state),
                _buildSearchAndFilters(),
                Expanded(
                  child: visitors.isEmpty
                      ? _buildEmptyState(
                          state.visitors.isEmpty,
                        )
                      : _buildVisitorList(visitors),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(VisitorState state) {
   final cards = [
    _SummaryData(
      'Total Visitors',
      state.totalVisitors,
      Icons.people_outline,
      Colors.blue,
    ),
    _SummaryData(
      'Pending',
      state.pendingVisitors,
      Icons.pending_actions,
      Colors.orange,
    ),
    _SummaryData(
      'Approved',
      state.approvedVisitors,
      Icons.check_box_outlined,
      const Color(0xFFE93691),
    ),
    _SummaryData(
      'Inside Now',
      state.insideNow,
      Icons.bolt,
      Colors.green,
    ),
  ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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



Widget _buildSearchAndFilters() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search + Filter button
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE8EAF0),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search visitors...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 21,
                      color: Color(0xFF8992A3),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Filter icon button
            Material(
              color: _showFilters
                  ? primaryColor.withValues(alpha: 0.10)
                  : const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _showFilters = !_showFilters;
                  });
                },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showFilters
                          ? primaryColor
                          : const Color(0xFFE3E6ED),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        color: _showFilters
                            ? primaryColor
                            : const Color(0xFF667085),
                        size: 22,
                      ),
                      if (_selectedStatus != 'All' ||
                          _selectedType != 'All')
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Expandable filters
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showFilters
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Icon(
                          Icons.filter_list_rounded,
                          color: primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 7),
                        const Text(
                          'Filter Visitors',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF253047),
                          ),
                        ),
                        const Spacer(),
                        if (_selectedStatus != 'All' ||
                            _selectedType != 'All')
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedStatus = 'All';
                                _selectedType = 'All';
                              });
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _filterDropdown(
                            icon: Icons.flag_outlined,
                            label: 'Status',
                            value: _selectedStatus,
                            values: const [
                              'All',
                              'Pending',
                              'Approved',
                              'Rejected',
                              'Cancelled',
                              'Inside',
                              'Exited',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _filterDropdown(
                            icon: Icons.category_outlined,
                            label: 'Type',
                            value: _selectedType,
                            values: const [
                              'All',
                              'Guest',
                              'Delivery',
                              'Service',
                              'Staff',
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    ),
  );
}

Widget _filterDropdown({
  required IconData icon,
  required String label,
  required String value,
  required List<String> values,
  required ValueChanged<String> onChanged,
}) {
  return Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: value == 'All'
            ? const Color(0xFFE3E6ED)
            : primaryColor.withValues(alpha: 0.45),
      ),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: value == 'All'
              ? const Color(0xFF8992A3)
              : primaryColor,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 19,
                color: Color(0xFF667085),
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF344054),
              ),
              items: values.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item == 'All' ? 'All $label' : item,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildVisitorList(List<VisitorPassModel> visitors) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: visitors.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final visitor = visitors[index];

        return _buildVisitorCard(visitor);
      },
    );
  }

  Widget _buildVisitorCard(VisitorPassModel visitor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    primaryColor.withValues(alpha: 0.10),
                child: const Icon(
                  Icons.person_outline,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visitor.visitorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      visitor.mobileNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(visitor.status),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (action) {
                  switch (action) {
                    case 'edit':
                      _openEditVisitor(visitor);
                      break;
                    case 'approve':
                      _updateStatus(visitor, 'Approved');
                      break;
                    case 'reject':
                      _updateStatus(visitor, 'Rejected');
                      break;
                    case 'cancel':
                      _updateStatus(visitor, 'Cancelled');
                      break;
                    case 'delete':
                      _deleteVisitor(visitor);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: _MenuLabel(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'approve',
                    child: _MenuLabel(
                      icon: Icons.check_circle_outline,
                      label: 'Approve',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reject',
                    child: _MenuLabel(
                      icon: Icons.cancel_outlined,
                      label: 'Reject',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'cancel',
                    child: _MenuLabel(
                      icon: Icons.block_outlined,
                      label: 'Cancel Pass',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: _MenuLabel(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          _detailRow('Resident / Flat', visitor.resident),
          _detailRow('Visitor Type', visitor.type),
          _detailRow(
            'Vehicle Number',
            visitor.vehicleNumber.isEmpty
                ? '-'
                : visitor.vehicleNumber,
          ),
          _detailRow(
            'Expected Arrival',
            visitor.expectedAt.toString(),
          ),
          _detailRow(
            'Valid Until',
            visitor.validUntil.toString(),
          ),
          _detailRow(
            'Purpose',
            visitor.purpose.isEmpty ? '-' : visitor.purpose,
          ),
          _detailRow(
            'Company / Service',
            visitor.companyService.isEmpty
                ? '-'
                : visitor.companyService,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final normalized = status.toLowerCase();

    Color color = Colors.orange;
    if (normalized == 'approved' || normalized == 'inside') {
      color = Colors.green;
    } else if (normalized == 'rejected' ||
        normalized == 'cancelled') {
      color = Colors.red;
    } else if (normalized == 'exited') {
      color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool noRecords) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_walk_rounded,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            Text(
              noRecords ? 'No Visitors Found' : 'No Matching Visitors',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noRecords
                  ? 'There are no visitor records yet.'
                  : 'Try changing your search or filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            if (noRecords) ...[
              const SizedBox(height: 14),
              const Text(
                'Tap Add Visitor to create a new gate pass.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryData {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SummaryData(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}

class _MenuLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuLabel({
    required this.icon,
    required this.label,
    this.color = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: color),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 13),
        ),
      ],
    );
  }
}
