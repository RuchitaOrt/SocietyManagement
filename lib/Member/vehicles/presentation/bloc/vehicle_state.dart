
import '../../domain/vehicle_model.dart';

enum VehicleStatus {
  initial,
  loading,
  success,
  failure,
}

class VehicleState {
  final VehicleStatus status;
  final List<VehicleModel> vehicles;
  final String? errorMessage;

  const VehicleState({
    this.status = VehicleStatus.initial,
    this.vehicles = const [],
    this.errorMessage,
  });

  VehicleState copyWith({
    VehicleStatus? status,
    List<VehicleModel>? vehicles,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VehicleState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
