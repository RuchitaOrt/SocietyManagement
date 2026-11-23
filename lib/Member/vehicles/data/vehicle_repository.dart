
import '../domain/vehicle_model.dart';

abstract class VehicleRepository {
  Future<List<VehicleModel>> getVehicles();

  Future<void> addVehicle(VehicleModel vehicle);
}

class VehicleRepositoryImpl implements VehicleRepository {
  final List<VehicleModel> _vehicles = [
    const VehicleModel(
      id: '1',
      vehicleType: '4-Wheeler (Car)',
      licensePlate: 'MH-12-AB-1234',
      makeAndModel: 'Honda City',
    ),
  ];

  @override
  Future<List<VehicleModel>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_vehicles);
  }

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    _vehicles.insert(0, vehicle);
  }
}
