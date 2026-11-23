
import 'package:flutter_bloc/flutter_bloc.dart';

import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc
    extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(const RegistrationState()) {
    on<RegistrationNextStep>((event, emit) {
      // Society details -> Admin account
      if (state.currentStep == 0) {
        emit(state.copyWith(currentStep: 1));
      }
    });

    on<RegistrationPreviousStep>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<RegistrationOtpVerified>((event, emit) {
      // Admin OTP verified -> Plan & Legal
      if (state.currentStep == 1) {
        emit(state.copyWith(currentStep: 2));
      }
    });

    on<RegistrationComplete>((event, emit) {
      emit(state.copyWith(status: RegistrationStatus.completed));
    });
  }
}
