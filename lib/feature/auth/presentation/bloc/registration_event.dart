
abstract class RegistrationEvent {}

class RegistrationNextStep extends RegistrationEvent {}

class RegistrationPreviousStep extends RegistrationEvent {}

class RegistrationOtpVerified extends RegistrationEvent {}

class RegistrationComplete extends RegistrationEvent {}
