
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc({
    TransactionRepository? repository,
  })  : repository = repository ?? InMemoryTransactionRepository(),
        super(const TransactionState()) {
    // Load transactions
    on<TransactionsRequested>((event, emit) async {
      debugPrint('TransactionBloc: Loading transactions');

      emit(state.copyWith(
        isLoading: true,
        clearError: true,
      ));

      try {
        final items = await this.repository.getTransactions();

        debugPrint('TransactionBloc: Loaded ${items.length} transactions');

        emit(state.copyWith(
          transactions: items,
          isLoading: false,
          clearError: true,
        ));
      } catch (e, stackTrace) {
        debugPrint('TransactionBloc LOAD ERROR: $e');
        debugPrintStack(stackTrace: stackTrace);

        emit(state.copyWith(
          isLoading: false,
          error: e.toString(),
        ));
      }
    });

    // Add transaction
    on<TransactionAdded>((event, emit) async {
      try {
        debugPrint('TransactionBloc: Adding transaction');
        debugPrint('Description: ${event.transaction.description}');
        debugPrint('Amount: ${event.transaction.amount}');

        await this.repository.addTransaction(event.transaction);

        debugPrint('TransactionBloc: Transaction added to repository');

        final items = await this.repository.getTransactions();

        debugPrint('TransactionBloc: Total transactions = ${items.length}');

        final newState = state.copyWith(
          transactions: items,
          clearError: true,
        );

        debugPrint(
          'Before emit: ${newState.transactions.length} transactions',
        );

        emit(newState);

        debugPrint('TransactionBloc: Updated state emitted');
      } catch (e, stackTrace) {
        debugPrint('TransactionBloc ADD ERROR: $e');
        debugPrintStack(stackTrace: stackTrace);

        emit(state.copyWith(error: e.toString()));
      }
    });

    // Delete transaction
    on<TransactionDeleted>((event, emit) async {
      try {
        debugPrint('TransactionBloc: Deleting transaction ${event.id}');

        await this.repository.deleteTransaction(event.id);

        final items = await this.repository.getTransactions();

        emit(state.copyWith(
          transactions: items,
          clearError: true,
        ));

        debugPrint('TransactionBloc: Transaction deleted successfully');
      } catch (e, stackTrace) {
        debugPrint('TransactionBloc DELETE ERROR: $e');
        debugPrintStack(stackTrace: stackTrace);

        emit(state.copyWith(error: e.toString()));
      }
    });

    // Search transactions
    on<TransactionSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });

    // Filter by transaction type
    on<TransactionTypeFilterChanged>((event, emit) {
      emit(state.copyWith(
        selectedType: event.type,
        clearType: event.type == null,
      ));
    });

    // Reset filters
    on<TransactionFiltersReset>((event, emit) {
      emit(state.copyWith(
        searchQuery: '',
        clearType: true,
      ));
    });
  }
}
