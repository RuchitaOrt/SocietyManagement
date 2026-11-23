
import 'package:society_management/Member/Notice/presentation/bloc/NoticeModel.dart';

enum NoticesStatus {
  initial,
  loading,
  success,
  failure,
}

class NoticesState {
  final NoticesStatus status;
  final List<NoticeModel> notices;
  final String selectedFilter;
  final String searchQuery;
  final String? errorMessage;

  const NoticesState({
    this.status = NoticesStatus.initial,
    this.notices = const [],
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  List<NoticeModel> get filteredNotices {
    return notices.where((notice) {
      final matchesFilter =
          selectedFilter == 'All' ||
          (selectedFilter == 'Unread' && !notice.isRead) ||
          notice.category == selectedFilter;

      final matchesSearch =
          notice.title.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ||
          notice.description.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );

      return matchesFilter && matchesSearch;
    }).toList();
  }

  NoticesState copyWith({
    NoticesStatus? status,
    List<NoticeModel>? notices,
    String? selectedFilter,
    String? searchQuery,
    String? errorMessage,
  }) {
    return NoticesState(
      status: status ?? this.status,
      notices: notices ?? this.notices,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }
}