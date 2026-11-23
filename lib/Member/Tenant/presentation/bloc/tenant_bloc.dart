
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/tenant_repository.dart';
import 'tenant_event.dart';
import 'tenant_state.dart';

class NomineeBloc extends Bloc<TenantEvent, NomineeState> {
  final TenantRepository repository;

  NomineeBloc({
    required this.repository,
  }) : super(const NomineeState()) {
    on<TenantRequested>(_loadNominees);
    on<TenantRefreshed>(_loadNominees);
  }

  Future<void> _loadNominees(
    TenantEvent event,
    Emitter<NomineeState> emit,
  ) async {
    emit(state.copyWith(
      status: NomineeStatus.loading,
      clearError: true,
    ));

    try {
      final nominees = await repository.getNominees();

      emit(state.copyWith(
        status: NomineeStatus.success,
        nominees: nominees,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NomineeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
