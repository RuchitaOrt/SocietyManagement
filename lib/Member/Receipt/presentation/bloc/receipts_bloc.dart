
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/Receipt/presentation/data/repository/receipt_repository.dart';

import 'receipts_event.dart';
import 'receipts_state.dart';

class ReceiptsBloc extends Bloc<ReceiptsEvent, ReceiptsState> {
  final ReceiptRepository repository;

  ReceiptsBloc(this.repository)
      : super(const ReceiptsState()) {
    on<LoadReceipts>(_loadReceipts);
    on<RefreshReceipts>(_refreshReceipts);
    on<SearchReceipts>(_searchReceipts);
    on<FilterReceiptsByMonth>(_filterByMonth);
  }

  Future<void> _loadReceipts(
    LoadReceipts event,
    Emitter<ReceiptsState> emit,
  ) async {
    emit(state.copyWith(status: ReceiptsStatus.loading));

    try {
      final receipts = await repository.getReceipts();

      emit(state.copyWith(
        status: ReceiptsStatus.success,
        receipts: receipts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReceiptsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _refreshReceipts(
    RefreshReceipts event,
    Emitter<ReceiptsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ReceiptsStatus.loading));

      final receipts = await repository.getReceipts();

      emit(state.copyWith(
        status: ReceiptsStatus.success,
        receipts: receipts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ReceiptsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _searchReceipts(
    SearchReceipts event,
    Emitter<ReceiptsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _filterByMonth(
    FilterReceiptsByMonth event,
    Emitter<ReceiptsState> emit,
  ) {
    emit(state.copyWith(selectedMonth: event.month));
  }
}
