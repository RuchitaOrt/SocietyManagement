import '../domain/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<CashbookTransaction>> getTransactions();
  Future<void> addTransaction(CashbookTransaction transaction);
  Future<void> deleteTransaction(String id);
}

/// Demo implementation. Replace with an API-backed repository when endpoints
/// and request/response models are available.
class InMemoryTransactionRepository implements TransactionRepository {
  final List<CashbookTransaction> _transactions = [];

  @override
  Future<List<CashbookTransaction>> getTransactions() async {
    return List.unmodifiable(_transactions);
  }

  @override
  Future<void> addTransaction(
    CashbookTransaction transaction,
  ) async {
    _transactions.insert(0, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((item) => item.id == id);
  }
}