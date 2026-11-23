
import 'package:equatable/equatable.dart';

import '../../domain/transaction_model.dart';

class TransactionState extends Equatable {
  final List<CashbookTransaction> transactions;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final TransactionType? selectedType;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedType,
  });

  // Filtered transactions
  List<CashbookTransaction> get filteredTransactions {
    final query = searchQuery.trim().toLowerCase();

    return transactions.where((item) {
      final matchesQuery = query.isEmpty ||
          item.description.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.memberOrParty.toLowerCase().contains(query) ||
          item.bank.toLowerCase().contains(query);

      final matchesType =
          selectedType == null || item.type == selectedType;

      return matchesQuery && matchesType;
    }).toList();
  }

  // Total credit
  double get totalCredit => transactions
      .where((e) => e.type == TransactionType.credit)
      .fold(0.0, (sum, e) => sum + e.amount);

  // Total debit
  double get totalDebit => transactions
      .where((e) => e.type == TransactionType.debit)
      .fold(0.0, (sum, e) => sum + e.amount);

  // Net balance
  double get netBalance => totalCredit - totalDebit;

  // Credit count
  int get creditCount =>
      transactions.where((e) => e.type == TransactionType.credit).length;

  // Debit count
  int get debitCount =>
      transactions.where((e) => e.type == TransactionType.debit).length;

  // Copy state
  TransactionState copyWith({
    List<CashbookTransaction>? transactions,
    bool? isLoading,
    String? error,
    String? searchQuery,
    TransactionType? selectedType,
    bool clearError = false,
    bool clearType = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType
          ? null
          : selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        isLoading,
        error,
        searchQuery,
        selectedType,
      ];
}
