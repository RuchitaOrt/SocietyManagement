
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/ParkingSlotModel.dart';


// EVENTS

abstract class ParkingSlotEvent {}

class ParkingSlotCreated extends ParkingSlotEvent {
  final ParkingSlotModel slot;

  ParkingSlotCreated(this.slot);
}

class ParkingSlotDeleted extends ParkingSlotEvent {
  final ParkingSlotModel slot;

  ParkingSlotDeleted(this.slot);
}

// STATE

class ParkingSlotState {
  final List<ParkingSlotModel> slots;

  const ParkingSlotState({
    this.slots = const [],
  });

  int get totalSlots => slots.length;

  int get twoWheelerCount =>
      slots.where((e) => e.slotType == '2-Wheeler').length;

  int get fourWheelerCount =>
      slots.where((e) => e.slotType == '4-Wheeler').length;

  ParkingSlotState copyWith({
    List<ParkingSlotModel>? slots,
  }) {
    return ParkingSlotState(
      slots: slots ?? this.slots,
    );
  }
}

// BLOC

class ParkingSlotBloc
    extends Bloc<ParkingSlotEvent, ParkingSlotState> {
  ParkingSlotBloc() : super(const ParkingSlotState()) {
    on<ParkingSlotCreated>((event, emit) {
      final updatedSlots = List<ParkingSlotModel>.from(
        state.slots,
      );

      updatedSlots.add(event.slot);

      emit(state.copyWith(slots: updatedSlots));
    });

    on<ParkingSlotDeleted>((event, emit) {
      final updatedSlots = List<ParkingSlotModel>.from(
        state.slots,
      );

      updatedSlots.remove(event.slot);

      emit(state.copyWith(slots: updatedSlots));
    });
  }
}
