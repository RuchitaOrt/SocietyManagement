enum RegistrationStatus {
  initial,
  completed,
}

class RegistrationState {
  final int currentStep;
  final RegistrationStatus status;

  const RegistrationState({
    this.currentStep = 0,
    this.status = RegistrationStatus.initial,
  });

  RegistrationState copyWith({
    int? currentStep,
    RegistrationStatus? status,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
    );
  }
}