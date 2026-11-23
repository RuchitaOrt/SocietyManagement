
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/nominee_repository.dart';
import 'nominee_event.dart';
import 'nominee_state.dart';

class NomineeBloc extends Bloc<NomineeEvent, NomineeState> {
  final NomineeRepository repository;

  NomineeBloc({
    required this.repository,
  }) : super(const NomineeState()) {
    on<NomineesRequested>(_loadNominees);
    on<NomineesRefreshed>(_loadNominees);
  }

  Future<void> _loadNominees(
    NomineeEvent event,
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
