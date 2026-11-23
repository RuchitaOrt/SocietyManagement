import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_event.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_model.dart';
import 'package:society_management/feature/society_setup/presentation/ComplaintManagement/complaint_state.dart';

import '../widgets/ComplaintManagement/raise_complaint_bottom_sheet.dart';

const Color complaintPrimary = Color(0xFFE93691);

class ComplaintManagementScreen extends StatefulWidget {
  const ComplaintManagementScreen({super.key});

  @override
  State<ComplaintManagementScreen> createState() =>
      _ComplaintManagementScreenState();
}

class _ComplaintManagementScreenState
    extends State<ComplaintManagementScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = 'All Status';

  Future<void> _openRaiseComplaint() async {
    final complaint = await showRaiseComplaintBottomSheet(
      context: context,
      societyName: 'Jainam',
    );

    if (!mounted || complaint == null) return;

    context.read<ComplaintBloc>().add(
          ComplaintCreated(complaint),
        );
  }

  List<ComplaintModel> _filterComplaints(
    List<ComplaintModel> complaints,
  ) {
    final query = searchController.text.trim().toLowerCase();

    return complaints.where((complaint) {
      final matchesSearch =
          complaint.title.toLowerCase().contains(query) ||
          complaint.description.toLowerCase().contains(query) ||
          complaint.category.toLowerCase().contains(query);

      final matchesStatus =
          selectedStatus == 'All Status' ||
          complaint.status.toLowerCase() ==
              selectedStatus.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          'Complaint Master',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 3),
      Text(
        'Manage resident complaints and resolutions',
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
        child: BlocBuilder<ComplaintBloc, ComplaintState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: complaintPrimary,
                ),
              );
            }

            if (state.errorMessage != null) {
              return Center(
                child: Text(state.errorMessage!),
              );
            }

            final complaints =
                _filterComplaints(state.complaints);

            return Column(
              children: [
                _buildSummaryCards(state),
                _buildSearchAndFilter(),
                Expanded(
                  child: complaints.isEmpty
                      ? _buildEmptyState(
                          state.complaints.isEmpty,
                        )
                      : _buildComplaintList(complaints),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRaiseComplaint,
        backgroundColor: complaintPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Raise Complaint',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ComplaintState state) {
    final cards = [
      _SummaryItem(
        'Total Complaints',
        state.totalComplaints,
        Icons.list_alt_rounded,
        Colors.blue,
      ),
      _SummaryItem(
        'Open',
        state.openComplaints,
        Icons.pending_actions_rounded,
        Colors.orange,
      ),
      _SummaryItem(
        'In Progress',
        state.inProgressComplaints,
        Icons.bolt_rounded,
        complaintPrimary,
      ),
      _SummaryItem(
        'Closed',
        state.closedComplaints,
        Icons.check_circle_outline,
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

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Row(
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
                controller: searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search complaints...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 21,
                    color: Color(0xFF8992A3),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
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
          Container(
            height: 48,
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE3E6ED),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                ),
                items: [
                  'All Status',
                  'Open',
                  'In Progress',
                  'Closed',
                ].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintList(
    List<ComplaintModel> complaints,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: complaints.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildComplaintCard(complaints[index]);
      },
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint) {
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
              Expanded(
                child: Text(
                  complaint.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              _badge(complaint.status),
              PopupMenuButton<String>(
                onSelected: (action) {
                  if (action == 'delete') {
                    context.read<ComplaintBloc>().add(
                          ComplaintDeleted(complaint),
                        );
                  } else {
                    context.read<ComplaintBloc>().add(
                          ComplaintStatusChanged(
                            complaint,
                            action,
                          ),
                        );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'In Progress',
                    child: Text('Mark In Progress'),
                  ),
                  const PopupMenuItem(
                    value: 'Closed',
                    child: Text('Mark Closed'),
                  ),
                  const PopupMenuItem(
                    value: 'Open',
                    child: Text('Mark Open'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          _detailRow('Category', complaint.category),
          _detailRow('Society', complaint.society),
          _detailRow('Priority', complaint.priority),
          _detailRow('Resident', complaint.resident),
          _detailRow('Assigned To', complaint.assignedTo),
          _detailRow('Created', complaint.createdAt.toString()),
          _detailRow('Description', complaint.description),
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
            width: 110,
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

  Widget _badge(String status) {
    Color color;

    switch (status) {
      case 'Closed':
        color = Colors.green;
        break;
      case 'In Progress':
        color = Colors.blue;
        break;
      default:
        color = Colors.orange;
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
              Icons.assignment_outlined,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            Text(
              noRecords
                  ? 'No Complaints Found'
                  : 'No Matching Complaints',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noRecords
                  ? 'Raise a new complaint to add your first record.'
                  : 'Try changing your search or filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SummaryItem(
    this.title,
    this.count,
    this.icon,
    this.color,
  );
}