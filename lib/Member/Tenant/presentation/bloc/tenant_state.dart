
import '../../domain/tenant_model.dart';

enum NomineeStatus {
  initial,
  loading,
  success,
  failure,
}

class NomineeState {
  final NomineeStatus status;
  final List<TenantModel> nominees;
  final String? errorMessage;

  const NomineeState({
    this.status = NomineeStatus.initial,
    this.nominees = const [],
    this.errorMessage,
  });

  NomineeState copyWith({
    NomineeStatus? status,
    List<TenantModel>? nominees,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NomineeState(
      status: status ?? this.status,
      nominees: nominees ?? this.nominees,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
