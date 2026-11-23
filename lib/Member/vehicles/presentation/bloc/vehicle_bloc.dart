
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/vehicle_repository.dart';
import '../../domain/vehicle_model.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository repository;

  VehicleBloc({
    required this.repository,
  }) : super(const VehicleState()) {
    on<VehiclesRequested>(_loadVehicles);
    on<VehiclesRefreshed>(_loadVehicles);
    on<VehicleAdded>(_addVehicle);
  }

  Future<void> _loadVehicles(
    VehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    emit(state.copyWith(
      status: VehicleStatus.loading,
      clearError: true,
    ));

    try {
      final vehicles = await repository.getVehicles();

      emit(state.copyWith(
        status: VehicleStatus.success,
        vehicles: vehicles,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VehicleStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _addVehicle(
    VehicleAdded event,
    Emitter<VehicleState> emit,
  ) async {
    try {
      await repository.addVehicle(event.vehicle);

      final vehicles = await repository.getVehicles();

      emit(state.copyWith(
        status: VehicleStatus.success,
        vehicles: vehicles,
        clearError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: VehicleStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
