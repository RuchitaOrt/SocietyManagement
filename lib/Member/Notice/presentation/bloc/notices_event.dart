abstract class NoticesEvent {}

class LoadNotices extends NoticesEvent {}

class ChangeNoticeFilter extends NoticesEvent {
  final String filter;
  ChangeNoticeFilter(this.filter);
}

class SearchNotices extends NoticesEvent {
  final String query;
  SearchNotices(this.query);
}

class MarkAllNoticesRead extends NoticesEvent {}

class RefreshNotices extends NoticesEvent {}