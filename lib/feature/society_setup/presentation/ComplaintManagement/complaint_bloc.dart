import 'package:flutter_bloc/flutter_bloc.dart';

import 'complaint_event.dart';
import 'complaint_state.dart';

class ComplaintBloc extends Bloc<ComplaintEvent, ComplaintState> {
  ComplaintBloc() : super(const ComplaintState()) {
    on<ComplaintCreated>((event, emit) {
      emit(state.copyWith(
        complaints: [event.complaint, ...state.complaints],
      ));
    });

    on<ComplaintStatusChanged>((event, emit) {
      final updatedComplaints = state.complaints.map((complaint) {
        if (complaint == event.complaint) {
          return complaint.copyWithStatus(event.status);
        }
        return complaint;
      }).toList();

      emit(state.copyWith(complaints: updatedComplaints));
    });

    on<ComplaintDeleted>((event, emit) {
      emit(state.copyWith(
        complaints: state.complaints
            .where((complaint) => complaint != event.complaint)
            .toList(),
      ));
    });
  }
}