
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/Member/VisitorPass/presentation/repository/visitor_pass_repository.dart';


import 'VisitorPassEvent.dart';
import 'VisitorPassState.dart';

class VisitorPassBloc
    extends Bloc<VisitorPassEvent, VisitorPassState> {
  final VisitorPassRepository repository;

  VisitorPassBloc(this.repository)
      : super(const VisitorPassState()) {
    on<LoadVisitorPasses>(_loadVisitors);
    on<RefreshVisitorPasses>(_refreshVisitors);
    on<AddVisitorPass>(_addVisitor);
  }

  Future<void> _loadVisitors(
    LoadVisitorPasses event,
    Emitter<VisitorPassState> emit,
  ) async {
    emit(state.copyWith(
      status: VisitorPassStatus.loading,
    ));

    try {
      final visitors = await repository.getVisitorPasses();

      emit(state.copyWith(
        status: VisitorPassStatus.success,
        visitors: visitors,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VisitorPassStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _refreshVisitors(
    RefreshVisitorPasses event,
    Emitter<VisitorPassState> emit,
  ) async {
    try {
      final visitors = await repository.getVisitorPasses();

      emit(state.copyWith(
        status: VisitorPassStatus.success,
        visitors: visitors,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VisitorPassStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _addVisitor(
    AddVisitorPass event,
    Emitter<VisitorPassState> emit,
  ) async {
    emit(state.copyWith(isAdding: true));

    try {
      final visitor = await repository.createVisitorPass(
        event.visitor,
      );

      emit(state.copyWith(
        status: VisitorPassStatus.success,
        visitors: [
          visitor,
          ...state.visitors,
        ],
        isAdding: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isAdding: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
