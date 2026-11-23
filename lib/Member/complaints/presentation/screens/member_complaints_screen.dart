
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

class MemberComplaintsScreen extends StatefulWidget {
  const MemberComplaintsScreen({super.key});

  @override
  State<MemberComplaintsScreen> createState() =>
      _MemberComplaintsScreenState();
}

class _MemberComplaintsScreenState
    extends State<MemberComplaintsScreen> {
  static const Color pink = Color(0xFFE93691);
  static const Color orange = Color(0xFFF97316);
  static const Color page = Color(0xFFF3F6FA);
  static const Color navy = Color(0xFF17264B);
  static const Color muted = Color(0xFF91A0B8);
  static const Color border = Color(0xFFE3E9F2);

  final List<ComplaintModel> complaints = [
    ComplaintModel(
      category: 'General',
      title: 'Water leakage',
      description: 'Water leakage near the parking area.',
      priority: 'Medium',
      status: 'Open',
      flat: 'A-201',
      date: DateTime.now(),
    ),
  ];

  Future<void> _raiseComplaint() async {
    final complaint = await showModalBottomSheet<ComplaintModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RaiseComplaintBottomSheet(),
    );

    if (complaint == null || !mounted) return;

    setState(() {
      complaints.insert(0, complaint);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaint submitted successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _refreshComplaints() async {
    // Connect your complaint BLoC/API refresh event here.
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complaints refreshed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color(0xFFE95B5B);
      case 'in progress':
        return orange;
      case 'resolved':
        return const Color(0xFF16A36A);
      case 'closed':
        return muted;
      default:
        return pink;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Low':
        return const Color(0xFF16A36A);
      default:
        return orange;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} '
        '${date.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: AdminColors.page,
          appBar: AppBar(
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
                'My Complaints',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'View complaint status and history | Ruchita | Flat 201 | A',
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
         
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
          
            Expanded(
              child: RefreshIndicator(
                color: pink,
                onRefresh: _refreshComplaints,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                  children: [
                    _buildRaiseButton(),
                    const SizedBox(height: 20),
                    // _buildSummary(),
                    // const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Complaint History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: navy,
                            ),
                          ),
                        ),
                        Text(
                          '${complaints.length} complaints',
                          style: const TextStyle(
                            color: muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (complaints.isEmpty)
                      _buildEmptyState()
                    else
                      ...complaints.map(_buildComplaintCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildRaiseButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [pink, orange],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: pink.withValues(alpha: 0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _raiseComplaint,
          borderRadius: BorderRadius.circular(18),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raise a Complaint',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Submit a new request to society admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final openCount = complaints
        .where((c) => c.status == 'Open')
        .length;

    final progressCount = complaints
        .where((c) => c.status == 'In Progress')
        .length;

    final resolvedCount = complaints
        .where((c) => c.status == 'Resolved')
        .length;

    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            'Open',
            openCount.toString(),
            Icons.error_outline_rounded,
            const Color(0xFFE95B5B),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
            'In Progress',
            progressCount.toString(),
            Icons.hourglass_top_rounded,
            orange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
            'Resolved',
            resolvedCount.toString(),
            Icons.check_circle_outline_rounded,
            const Color(0xFF16A36A),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              color: navy,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint) {
    final statusColor = _statusColor(complaint.status);
    final priorityColor = _priorityColor(complaint.priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F1FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE5D8FF),
                  ),
                ),
                child: Text(
                  complaint.category,
                  style: const TextStyle(
                    color: Color(0xFF7855B7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  complaint.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            complaint.title,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            complaint.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.home_outlined,
                size: 15,
                color: muted,
              ),
              const SizedBox(width: 5),
              Text(
                'Flat: ${complaint.flat}',
                style: const TextStyle(
                  color: navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                Icon(
                  complaint.status == 'Open'
                      ? Icons.access_time_rounded
                      : Icons.info_outline_rounded,
                  color: muted,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    complaint.status == 'Open'
                        ? 'Awaiting review & assignment by admin'
                        : 'Complaint status: ${complaint.status}',
                    style: const TextStyle(
                      color: muted,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          const Divider(height: 1, color: border),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Priority:',
                style: TextStyle(
                  color: muted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: priorityColor,
                      size: 7,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      complaint.priority,
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(complaint.date),
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
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
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: 52,
            color: muted,
          ),
          SizedBox(height: 12),
          Text(
            'No Complaints Yet',
            style: TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Raise a complaint if you need help from society admin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

const Color _primaryColor = Color(0xFFE93691);
const Color _textColor = Color(0xFF202B43);
const Color _hintColor = Color(0xFF91A0B8);

class RaiseComplaintBottomSheet extends StatefulWidget {
  const RaiseComplaintBottomSheet({super.key});

  @override
  State<RaiseComplaintBottomSheet> createState() =>
      _RaiseComplaintBottomSheetState();
}

class _RaiseComplaintBottomSheetState
    extends State<RaiseComplaintBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = 'General';
  String _priority = 'Medium';

  final List<String> _categories = [
    'General',
    'Maintenance',
    'Security',
    'Parking',
    'Plumbing',
    'Electrical',
    'Housekeeping',
    'Other',
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _fieldLabel(String label) {
    return Row(
      children: [
        CommonText(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF44516A),
        ),
        const CommonText(
          text: ' *',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
      ],
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _hintColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE3E9F2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _primaryColor,
                width: 1.4,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: _textColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _complaintTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 7),
        CommonTextField(
          controller: controller,
          hintText: hint,
          textInputAction: maxLines == 1
              ? TextInputAction.next
              : TextInputAction.newline,
         
          keyboardType: maxLines > 1
              ? TextInputType.multiline
              : TextInputType.text,
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
        ),
      ],
    );
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) return;

    final complaint = ComplaintModel(
      category: _category,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      status: 'Open',
      flat: 'A-201',
      date: DateTime.now(),
    );

    Navigator.pop(context, complaint);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                12,
                18,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFCE7F0),
                    Color(0xFFFFEBD9),
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: CommonText(
                      text: 'Raise Complaint',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _dropdownField(
                        label: 'Category',
                        value: _category,
                        items: _categories,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      _dropdownField(
                        label: 'Priority',
                        value: _priority,
                        items: _priorities,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _priority = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      _complaintTextField(
                        label: 'Title',
                        hint: 'Short complaint title',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter complaint title';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _complaintTextField(
                        label: 'Description',
                        hint: 'Explain the issue clearly',
                        controller: _descriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter complaint description';
                          }
                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      CommonButton(
                        text: 'Submit Complaint',
                        icon: Icons.send_rounded,
                        onPressed: _submitComplaint,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComplaintModel {
  final String category;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String flat;
  final DateTime date;

  ComplaintModel({
    required this.category,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.flat,
    required this.date,
  });
}
