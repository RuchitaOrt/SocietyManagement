import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/Notice/presentation/bloc/notices_bloc.dart';
import 'package:society_management/Member/Notice/presentation/bloc/notices_event.dart';
import 'package:society_management/Member/Notice/presentation/bloc/notices_state.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';


class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoticesBloc()..add(LoadNotices()),
      child: const NoticesView(),
    );
  }
}


class NoticesView extends StatefulWidget {
  const NoticesView({super.key});

  @override
  State<NoticesView> createState() => _NoticesViewState();
}

class _NoticesViewState extends State<NoticesView> {
  final TextEditingController _searchController =
      TextEditingController();

  static const Color primaryPink = Color(0xFFEC268F);
  static const Color backgroundColor = Color(0xFFF6F6FC);
  static const Color darkText = Color(0xFF17264B);
  static const Color lightText = Color(0xFF7885A5);
  static const Color borderColor = Color(0xFFE9EAF2);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Keep your existing search field design
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EAF3)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<NoticesBloc>().add(SearchNotices(value));
        },
        style: const TextStyle(
          color: darkText,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          hintText: 'Search notices...',
          hintStyle: TextStyle(
            color: lightText,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: lightText,
            size: 23,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.page,

      // APP BAR UNCHANGED
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
                'Notices',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Society notices and announcements | Ruchita | Flat 201 | A',
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
        actions: [],
      ),

      body: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) {
          if (state.status == NoticesStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryPink,
              ),
            );
          }

          if (state.status == NoticesStatus.failure) {
            return _buildErrorState(
              state.errorMessage ?? 'Something went wrong',
            );
          }

          final unreadCount = state.filteredNotices
              .where((notice) => !notice.isRead)
              .length;

          return Column(
            children: [
              // SEARCH - unchanged
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 16, 20, 16,
                ),
                child: _buildSearchField(),
              ),

              // FILTER SECTION
              _buildFilterSection(state),

              // MARK ALL READ + COUNT
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20, 18, 20, 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'All Announcements',
                            style: TextStyle(
                              color: darkText,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.filteredNotices.length} notices available',
                            style: const TextStyle(
                              color: lightText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (unreadCount > 0)
                      InkWell(
                        onTap: () {
                          context.read<NoticesBloc>().add(
                            MarkAllNoticesRead(),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: primaryPink.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.done_all_rounded,
                                color: primaryPink,
                                size: 16,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Mark all read',
                                style: TextStyle(
                                  color: primaryPink,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // NOTICE LIST
              Expanded(
                child: RefreshIndicator(
                  color: primaryPink,
                  onRefresh: () async {
                    context.read<NoticesBloc>().add(
                      RefreshNotices(),
                    );
                  },
                  child: state.filteredNotices.isEmpty
                      ? ListView(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            _buildEmptyState(),
                          ],
                        )
                      : ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            20, 2, 20, 25,
                          ),
                          itemCount:
                              state.filteredNotices.length,
                          itemBuilder: (context, index) {
                            final notice =
                                state.filteredNotices[index];

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 13,
                              ),
                              child: _buildNoticeCard(notice),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // FILTER CHIPS
  Widget _buildFilterSection(NoticesState state) {
    final filters = [
      'All',
      'Unread',
      'Maintenance_bill',
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = state.selectedFilter == filter;

          IconData? icon;

          switch (filter) {
            case 'All':
              icon = Icons.grid_view_rounded;
              break;
            case 'Unread':
              icon = Icons.mark_email_unread_outlined;
              break;
            case 'Maintenance_bill':
              icon = Icons.receipt_long_outlined;
              break;
          }

          return InkWell(
            onTap: () {
              context.read<NoticesBloc>().add(
                ChangeNoticeFilter(filter),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? primaryPink
                    : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: selected
                      ? primaryPink
                      : borderColor,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: primaryPink.withValues(
                            alpha: 0.17,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: selected
                        ? Colors.white
                        : lightText,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    filter == 'Maintenance_bill'
                        ? 'Maintenance Bill'
                        : filter,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected
                          ? Colors.white
                          : darkText,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // NOTICE CARD
  Widget _buildNoticeCard(dynamic notice) {
    final isUnread = !notice.isRead;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isUnread
              ? primaryPink.withValues(alpha: 0.25)
              : borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            height: 47,
            width: 47,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isUnread
                    ? [
                        const Color(0xFFFCE7F3),
                        const Color(0xFFFFF0E5),
                      ]
                    : [
                        const Color(0xFFF0F2F8),
                        const Color(0xFFF6F7FB),
                      ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getNoticeIcon(notice.title),
              color: isUnread
                  ? primaryPink
                  : lightText,
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notice.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: darkText,
                          fontSize: 14,
                          fontWeight: isUnread
                              ? FontWeight.w800
                              : FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),

                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        height: 9,
                        width: 9,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: const BoxDecoration(
                          color: primaryPink,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  notice.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: lightText,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            color: lightText,
                            size: 13,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Society Notice',
                            style: TextStyle(
                              color: lightText,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    Text(
                      isUnread ? 'Unread' : 'Read',
                      style: TextStyle(
                        color: isUnread
                            ? primaryPink
                            : const Color(0xFF16A36A),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNoticeIcon(String title) {
    final text = title.toLowerCase();

    if (text.contains('maintenance') ||
        text.contains('bill')) {
      return Icons.receipt_long_rounded;
    }

    if (text.contains('water')) {
      return Icons.water_drop_outlined;
    }

    if (text.contains('meeting')) {
      return Icons.groups_rounded;
    }

    if (text.contains('security')) {
      return Icons.security_rounded;
    }

    if (text.contains('event')) {
      return Icons.event_available_rounded;
    }

    return Icons.campaign_rounded;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              color: primaryPink.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 42,
              color: primaryPink,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No Notices Found',
            style: TextStyle(
              color: darkText,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'There are no announcements available right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightText,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 45,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: darkText,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                context.read<NoticesBloc>().add(LoadNotices());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
