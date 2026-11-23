


import 'package:society_management/Member/Receipt/presentation/bloc/ReceiptModel.dart';

enum ReceiptsStatus {
  initial,
  loading,
  success,
  failure,
}

class ReceiptsState {
  final ReceiptsStatus status;
  final List<ReceiptModel> receipts;
  final String searchQuery;
  final String selectedMonth;
  final String? errorMessage;

  const ReceiptsState({
    this.status = ReceiptsStatus.initial,
    this.receipts = const [],
    this.searchQuery = '',
    this.selectedMonth = 'All Months',
    this.errorMessage,
  });

  List<ReceiptModel> get filteredReceipts {
    return receipts.where((receipt) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          receipt.receiptNumber.toLowerCase().contains(query) ||
          receipt.billNumber.toLowerCase().contains(query) ||
          receipt.paymentMode.toLowerCase().contains(query);

      final matchesMonth =
          selectedMonth == 'All Months' ||
          receipt.month == selectedMonth;

      return matchesSearch && matchesMonth;
    }).toList();
  }

  ReceiptsState copyWith({
    ReceiptsStatus? status,
    List<ReceiptModel>? receipts,
    String? searchQuery,
    String? selectedMonth,
    String? errorMessage,
  }) {
    return ReceiptsState(
      status: status ?? this.status,
      receipts: receipts ?? this.receipts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      errorMessage: errorMessage,
    );
  }
}
