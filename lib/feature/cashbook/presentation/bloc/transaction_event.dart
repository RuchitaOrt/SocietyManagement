import 'package:equatable/equatable.dart';

import '../../domain/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class TransactionsRequested extends TransactionEvent {
  const TransactionsRequested();
}

class TransactionAdded extends TransactionEvent {
  final CashbookTransaction transaction;
  const TransactionAdded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends TransactionEvent {
  final String id;
  const TransactionDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class TransactionSearchChanged extends TransactionEvent {
  final String query;
  const TransactionSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class TransactionTypeFilterChanged extends TransactionEvent {
  final TransactionType? type;
  const TransactionTypeFilterChanged(this.type);

  @override
  List<Object?> get props => [type];
}

class TransactionFiltersReset extends TransactionEvent {
  const TransactionFiltersReset();
}
