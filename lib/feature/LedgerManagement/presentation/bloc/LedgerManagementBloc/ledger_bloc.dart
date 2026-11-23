import 'package:flutter_bloc/flutter_bloc.dart';

import 'ledger_event.dart';
import 'ledger_model.dart';
import 'ledger_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  LedgerBloc() : super(const LedgerState()) {
    on<LedgerCreated>(_onLedgerCreated);
    on<LedgerDeleted>(_onLedgerDeleted);
    on<LedgerStatusChanged>(_onLedgerStatusChanged);
    on<LedgerSearchChanged>(_onLedgerSearchChanged);
  }

  void _onLedgerCreated(
    LedgerCreated event,
    Emitter<LedgerState> emit,
  ) {
    emit(
      state.copyWith(
        ledgers: [event.ledger, ...state.ledgers],
      ),
    );
  }

  void _onLedgerDeleted(
    LedgerDeleted event,
    Emitter<LedgerState> emit,
  ) {
    emit(
      state.copyWith(
        ledgers: state.ledgers
            .where((e) => e.id != event.id)
            .toList(),
      ),
    );
  }

  void _onLedgerStatusChanged(
    LedgerStatusChanged event,
    Emitter<LedgerState> emit,
  ) {
    final updatedLedgers = state.ledgers.map((ledger) {
      if (ledger.id == event.id) {
        return LedgerModel(
          id: ledger.id,
          society: ledger.society,
          accountGroup: ledger.accountGroup,
          ledgerName: ledger.ledgerName,
          ledgerCode: ledger.ledgerCode,
          ledgerType: ledger.ledgerType,
          openingBalance: ledger.openingBalance,
          balanceType: ledger.balanceType,
          isActive: event.isActive,
        );
      }
      return ledger;
    }).toList();

    emit(state.copyWith(ledgers: updatedLedgers));
  }

  void _onLedgerSearchChanged(
    LedgerSearchChanged event,
    Emitter<LedgerState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}