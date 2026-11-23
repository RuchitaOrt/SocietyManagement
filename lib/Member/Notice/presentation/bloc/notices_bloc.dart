import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/Notice/presentation/bloc/NoticeModel.dart';


import 'notices_event.dart';
import 'notices_state.dart';

class NoticesBloc extends Bloc<NoticesEvent, NoticesState> {
  NoticesBloc() : super(const NoticesState()) {
    on<LoadNotices>(_loadNotices);
    on<ChangeNoticeFilter>(_changeFilter);
    on<SearchNotices>(_searchNotices);
    on<MarkAllNoticesRead>(_markAllRead);
    on<RefreshNotices>(_refreshNotices);
  }

  Future<void> _loadNotices(
    LoadNotices event,
    Emitter<NoticesState> emit,
  ) async {
    emit(state.copyWith(status: NoticesStatus.loading));

    try {
      final notices = [
        const NoticeModel(
          id: '1',
          title: 'Maintenance bill generated',
          description:
              'Maintenance bill for November 2026 has been generated '
              'for all your flats. Please pay before due date 2026-12-20.',
          category: 'Maintenance_bill',
          createdAt: '2 days ago',
        ),
      ];

      emit(state.copyWith(
        status: NoticesStatus.success,
        notices: notices,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NoticesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _changeFilter(
    ChangeNoticeFilter event,
    Emitter<NoticesState> emit,
  ) {
    emit(state.copyWith(selectedFilter: event.filter));
  }

  void _searchNotices(
    SearchNotices event,
    Emitter<NoticesState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _markAllRead(
    MarkAllNoticesRead event,
    Emitter<NoticesState> emit,
  ) {
    final updatedNotices = state.notices
        .map((notice) => notice.copyWith(isRead: true))
        .toList();

    emit(state.copyWith(notices: updatedNotices));
  }

  Future<void> _refreshNotices(
    RefreshNotices event,
    Emitter<NoticesState> emit,
  ) async {
    add(LoadNotices());
  }
}