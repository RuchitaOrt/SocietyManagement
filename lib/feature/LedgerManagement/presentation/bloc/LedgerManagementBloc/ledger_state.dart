import 'ledger_model.dart';

class LedgerState {
  final List<LedgerModel> ledgers;
  final String searchQuery;

  const LedgerState({
    this.ledgers = const [],
    this.searchQuery = '',
  });

  List<LedgerModel> get filteredLedgers {
    if (searchQuery.trim().isEmpty) return ledgers;

    final query = searchQuery.toLowerCase();

    return ledgers.where((ledger) {
      return ledger.ledgerName.toLowerCase().contains(query) ||
          ledger.accountGroup.toLowerCase().contains(query) ||
          ledger.ledgerCode.toLowerCase().contains(query);
    }).toList();
  }

  int get totalLedgers => ledgers.length;

  int get activeLedgers =>
      ledgers.where((e) => e.isActive).length;

  int get inactiveLedgers =>
      ledgers.where((e) => !e.isActive).length;

  LedgerState copyWith({
    List<LedgerModel>? ledgers,
    String? searchQuery,
  }) {
    return LedgerState(
      ledgers: ledgers ?? this.ledgers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}