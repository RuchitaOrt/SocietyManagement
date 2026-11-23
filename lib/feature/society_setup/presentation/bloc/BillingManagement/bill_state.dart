import 'bill_model.dart';

class BillState {
  final List<BillModel> bills;
  final String searchQuery;
  final String selectedWing;
  final String selectedMonth;
  final String selectedStatus;
  final bool isLoading;
  final String? errorMessage;

  const BillState({
    this.bills = const [],
    this.searchQuery = '',
    this.selectedWing = 'All Wings',
    this.selectedMonth = 'All Months',
    this.selectedStatus = 'All Status',
    this.isLoading = false,
    this.errorMessage,
  });

  int get totalBills => bills.length;

  int get unpaidBills =>
      bills.where((b) => b.status == 'Unpaid').length;

  int get partialBills =>
      bills.where((b) => b.status == 'Partial').length;

  int get paidBills =>
      bills.where((b) => b.status == 'Paid').length;

  double get totalBilled =>
      bills.fold(0, (sum, bill) => sum + bill.totalAmount);

  List<BillModel> get filteredBills {
    return bills.where((bill) {
      final search = searchQuery.toLowerCase();

      final matchesSearch =
          bill.flat.toLowerCase().contains(search) ||
          bill.owner.toLowerCase().contains(search) ||
          bill.society.toLowerCase().contains(search);

      final matchesWing =
          selectedWing == 'All Wings' ||
          bill.wing == selectedWing;

      final matchesMonth =
          selectedMonth == 'All Months' ||
          bill.financialMonth == selectedMonth;

      final matchesStatus =
          selectedStatus == 'All Status' ||
          bill.status == selectedStatus;

      return matchesSearch &&
          matchesWing &&
          matchesMonth &&
          matchesStatus;
    }).toList();
  }

  BillState copyWith({
    List<BillModel>? bills,
    String? searchQuery,
    String? selectedWing,
    String? selectedMonth,
    String? selectedStatus,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BillState(
      bills: bills ?? this.bills,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedWing: selectedWing ?? this.selectedWing,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}