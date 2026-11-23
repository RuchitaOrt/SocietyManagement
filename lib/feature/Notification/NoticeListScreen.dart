
import 'package:flutter/material.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

const Color primaryColor = Color(0xFFE93691);
const Color orangeColor = Color(0xFFF97316);
const Color pageColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF25324B);
const Color mutedColor = Color(0xFF71809A);
const Color borderColor = Color(0xFFE5EAF2);

class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({super.key});

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  final List<_NoticeItem> _notices = [
    _NoticeItem(
      society: 'Jainam',
      title: 'Important Society Announcement',
      message:
          'All residents are requested to attend the upcoming society meeting.',
      sendTo: 'All',
      channel: 'In App',
      createdAt: DateTime(2026, 11, 18),
    ),
  ];

  String _search = '';

  List<_NoticeItem> get _filteredNotices {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) return _notices;

    return _notices.where((notice) {
      return notice.title.toLowerCase().contains(query) ||
          notice.message.toLowerCase().contains(query) ||
          notice.sendTo.toLowerCase().contains(query) ||
          notice.channel.toLowerCase().contains(query) ||
          notice.society.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openNoticeForm({
    _NoticeItem? notice,
    int? index,
  }) async {
    final result = await showModalBottomSheet<_NoticeItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => _NoticeFormSheet(notice: notice),
    );

    if (!mounted || result == null) return;

    setState(() {
      if (index == null) {
        _notices.insert(0, result);
      } else {
        _notices[index] = result;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          index == null
              ? 'Notice sent successfully'
              : 'Notice updated successfully',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteNotice(_NoticeItem notice) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Notice?'),
        content: Text(
          'Are you sure you want to delete "${notice.title}"?',
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

    if (confirmed == true && mounted) {
      setState(() {
        _notices.remove(notice);
      });
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final notices = _filteredNotices;

    return Scaffold(
      backgroundColor: AdminColors.page,

     appBar: AppBar(
  centerTitle: false,
  backgroundColor: AdminColors.page,
  surfaceTintColor: AdminColors.page,
  elevation: 0,
  titleSpacing: 18,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [primaryColor, orangeColor],
        ).createShader(bounds),
        child: const Text(
          'Notification Master',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(height: 3),
      const Text(
        'Manage all society notifications',
        style: TextStyle(
          color: mutedColor,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  ),
),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoticeForm(),
        backgroundColor: primaryColor,
        elevation: 3,
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        label: const Text(
          'New Notification',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(),

            Expanded(
              child: notices.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        14,
                        16,
                        100,
                      ),
                      itemCount: notices.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final notice = notices[index];

                        return _buildNoticeCard(notice);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      color: AdminColors.page,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() => _search = value);
          },
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Search notifications...',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8992A3),
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              size: 21,
              color: Color(0xFF8992A3),
            ),
            suffixIcon: _search.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _search = '');
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
    );
  }

  Widget _buildNoticeCard(_NoticeItem notice) {
    final index = _notices.indexOf(notice);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notice.society,
                      style: const TextStyle(
                        color: mutedColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              _activeBadge(),

              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Color(0xFF667085),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _openNoticeForm(
                      notice: notice,
                      index: index,
                    );
                  } else if (value == 'delete') {
                    _deleteNotice(notice);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: _NoticeMenuLabel(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: _NoticeMenuLabel(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: borderColor),
          const SizedBox(height: 12),

          // Message
          Text(
            notice.message,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF52627D),
            ),
          ),

          const SizedBox(height: 14),

          // Details
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoChip(
                icon: Icons.people_outline_rounded,
                label: 'To: ${notice.sendTo}',
                color: const Color(0xFF3185D8),
                background: const Color(0xFFE8F3FF),
              ),
              _infoChip(
                icon: Icons.campaign_outlined,
                label: notice.channel,
                color: const Color(0xFF8B5BC7),
                background: const Color(0xFFF2EAFE),
              ),
            ],
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: mutedColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Created: ${_formatDate(notice.createdAt)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: mutedColor,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 14,
                color: Color(0xFF07965B),
              ),
              const SizedBox(width: 4),
              const Text(
                'Sent',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF07965B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF9E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'ACTIVE',
        style: TextStyle(
          color: Color(0xFF07965B),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            const Text(
              'No Notifications Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _search.isEmpty
                  ? 'There are no notifications yet.'
                  : 'Try changing your search.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: mutedColor,
                fontSize: 13,
              ),
            ),
            if (_search.isEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                'Tap New Notification to create a society notice.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: mutedColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NoticeMenuLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _NoticeMenuLabel({
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

class _NoticeItem {
  final String society;
  final String title;
  final String message;
  final String sendTo;
  final String channel;
  final DateTime createdAt;

  const _NoticeItem({
    required this.society,
    required this.title,
    required this.message,
    required this.sendTo,
    required this.channel,
    required this.createdAt,
  });
}

// ---------------------------------------------------------------------
// ADD / EDIT NOTIFICATION BOTTOM SHEET
// ---------------------------------------------------------------------

class _NoticeFormSheet extends StatefulWidget {
  final _NoticeItem? notice;

  const _NoticeFormSheet({this.notice});

  @override
  State<_NoticeFormSheet> createState() =>
      _NoticeFormSheetState();
}

class _NoticeFormSheetState extends State<_NoticeFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _messageController;

  String _sendTo = 'All';
  String _channel = 'In App';

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.notice?.title ?? '',
    );

    _messageController = TextEditingController(
      text: widget.notice?.message ?? '',
    );

    _sendTo = widget.notice?.sendTo ?? 'All';
    _channel = widget.notice?.channel ?? 'In App';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      _NoticeItem(
        society: widget.notice?.society ?? 'Jainam',
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        sendTo: _sendTo,
        channel: _channel,
        createdAt: DateTime.now(),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFADB8C8),
        fontSize: 12,
      ),
      filled: true,
      fillColor: const Color(0xFFFCFDFE),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .9,
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
            // Bottom sheet header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.notice == null
                              ? 'New Notification'
                              : 'Edit Notification',
                          style: const TextStyle(
                           fontWeight: FontWeight.w600,
                      color: Color(0xFF202B43),
                            fontSize: 18,
                           
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Create and send a society notice',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Form fields
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Notification Title *'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization:
                            TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter notification title';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          'Enter notification title',
                        ),
                      ),

                      const SizedBox(height: 16),

                      _fieldLabel('Message *'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _messageController,
                        minLines: 3,
                        maxLines: 5,
                        textCapitalization:
                            TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter notification message';
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          'Write your message...',
                        ),
                      ),

                      const SizedBox(height: 16),

                      _fieldLabel('Send To *'),
                      const SizedBox(height: 7),
                      DropdownButtonFormField<String>(
                        value: _sendTo,
                        decoration: _inputDecoration(
                          'Select recipients',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All Members'),
                          ),
                          DropdownMenuItem(
                            value: 'Members',
                            child: Text('Members'),
                          ),
                          DropdownMenuItem(
                            value: 'Owners',
                            child: Text('Owners'),
                          ),
                          DropdownMenuItem(
                            value: 'Tenants',
                            child: Text('Tenants'),
                          ),
                          DropdownMenuItem(
                            value: 'Staff',
                            child: Text('Society Staff'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sendTo = value);
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      _fieldLabel('Channels *'),
                      const SizedBox(height: 7),
                      DropdownButtonFormField<String>(
                        value: _channel,
                        decoration: _inputDecoration(
                          'Select channel',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'In App',
                            child: Text('In App Only'),
                          ),
                          DropdownMenuItem(
                            value: 'Email',
                            child: Text('Email'),
                          ),
                          DropdownMenuItem(
                            value: 'SMS',
                            child: Text('SMS'),
                          ),
                          DropdownMenuItem(
                            value: 'Push Notification',
                            child: Text('Push Notification'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _channel = value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: mutedColor,
                        side: const BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 16,
                      ),
                      label: Text(
                        widget.notice == null
                            ? 'Send Notice'
                            : 'Update Notice',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
