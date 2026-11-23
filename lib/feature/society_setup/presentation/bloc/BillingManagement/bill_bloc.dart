import 'package:flutter_bloc/flutter_bloc.dart';

import 'bill_model.dart';
import 'bill_event.dart';
import 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(const BillState()) {
    on<BillCreated>((event, emit) {
      emit(state.copyWith(
        bills: [...state.bills, ...event.bills],
      ));
    });

    on<BillDeleted>((event, emit) {
      emit(state.copyWith(
        bills: state.bills
            .where((bill) => bill != event.bill)
            .toList(),
      ));
    });

    on<BillStatusUpdated>((event, emit) {
      final updatedBills = state.bills.map((bill) {
        return bill == event.bill
            ? bill.copyWithStatus(event.status)
            : bill;
      }).toList();

      emit(state.copyWith(bills: updatedBills));
    });

    on<BillSearchChanged>((event, emit) {
      emit(state.copyWith(searchQuery: event.query));
    });

    on<BillFilterChanged>((event, emit) {
      emit(state.copyWith(
        selectedWing: event.wing,
        selectedMonth: event.month,
        selectedStatus: event.status,
      ));
    });
  }
}