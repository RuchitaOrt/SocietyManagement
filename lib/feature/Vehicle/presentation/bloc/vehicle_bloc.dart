
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/Vehicle/presentation/bloc/VehicleModel.dart';

abstract class VehicleEvent {}

class VehicleCreated extends VehicleEvent {
  final VehicleModel vehicle;
  VehicleCreated(this.vehicle);
}

class VehicleDeleted extends VehicleEvent {
  final VehicleModel vehicle;
  VehicleDeleted(this.vehicle);
}

class VehicleState {
  final List<VehicleModel> vehicles;

  const VehicleState({this.vehicles = const []});

  int get totalVehicles => vehicles.length;

  int get twoWheelerCount =>
      vehicles.where((v) => v.vehicleType == '2-Wheeler').length;

  int get fourWheelerCount =>
      vehicles.where((v) => v.vehicleType == '4-Wheeler').length;
}

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(const VehicleState()) {
    on<VehicleCreated>((event, emit) {
      final exists = state.vehicles.any(
        (v) => v.licensePlate.toLowerCase() ==
            event.vehicle.licensePlate.toLowerCase(),
      );

      if (exists) return;

      emit(VehicleState(
        vehicles: [...state.vehicles, event.vehicle],
      ));
    });

    on<VehicleDeleted>((event, emit) {
      emit(VehicleState(
        vehicles: state.vehicles
            .where((v) => v != event.vehicle)
            .toList(),
      ));
    });
  }
}
