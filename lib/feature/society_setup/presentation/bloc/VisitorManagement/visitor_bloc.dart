
import 'package:flutter_bloc/flutter_bloc.dart';

import 'visitor_event.dart';
import 'visitor_state.dart';
class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc() : super(const VisitorState()) {

    on<VisitorPassCreated>((event, emit) {
      emit(state.copyWith(
        visitors: [...state.visitors, event.visitor],
      ));
    });

    on<VisitorPassStatusChanged>((event, emit) {
      final updatedVisitors = state.visitors.map((visitor) {
        if (identical(visitor, event.visitor)) {
          return visitor.copyWith(status: event.status);
        }
        return visitor;
      }).toList();

      emit(state.copyWith(visitors: updatedVisitors));
    });

    // DELETE EVENT HANDLER
    on<VisitorPassDeleted>((event, emit) {
      final updatedVisitors = state.visitors
          .where((visitor) => !identical(visitor, event.visitor))
          .toList();

      emit(state.copyWith(visitors: updatedVisitors));
    });
  }
}