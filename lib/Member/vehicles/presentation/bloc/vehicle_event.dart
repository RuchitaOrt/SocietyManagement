
import '../../domain/vehicle_model.dart';

abstract class VehicleEvent {}

class VehiclesRequested extends VehicleEvent {}

class VehicleAdded extends VehicleEvent {
  final VehicleModel vehicle;

  VehicleAdded(this.vehicle);
}

class VehiclesRefreshed extends VehicleEvent {}
