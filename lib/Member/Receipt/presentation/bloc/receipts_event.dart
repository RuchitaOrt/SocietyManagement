
abstract class ReceiptsEvent {}

class LoadReceipts extends ReceiptsEvent {}

class RefreshReceipts extends ReceiptsEvent {}

class SearchReceipts extends ReceiptsEvent {
  final String query;

  SearchReceipts(this.query);
}

class FilterReceiptsByMonth extends ReceiptsEvent {
  final String month;

  FilterReceiptsByMonth(this.month);
}
