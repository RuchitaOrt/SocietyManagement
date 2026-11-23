
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/staff_model.dart';


enum StaffAttendanceStatus { present, absent }

enum StaffFilter { all, present, absent }

abstract class SocietyStaffEvent {}

class AddStaffEvent extends SocietyStaffEvent {
  final StaffModel staff;
  AddStaffEvent(this.staff);
}

class UpdateStaffEvent extends SocietyStaffEvent {
  final StaffModel staff;
  UpdateStaffEvent(this.staff);
}

class DeleteStaffEvent extends SocietyStaffEvent {
  final String mobileNumber;
  DeleteStaffEvent(this.mobileNumber);
}

class ToggleStaffAttendanceEvent extends SocietyStaffEvent {
  final String mobileNumber;
  ToggleStaffAttendanceEvent(this.mobileNumber);
}

class ChangeStaffFilterEvent extends SocietyStaffEvent {
  final StaffFilter filter;
  ChangeStaffFilterEvent(this.filter);
}

class SocietyStaffState {
  final List<StaffModel> staffList;
  final Map<String, StaffAttendanceStatus> attendance;
  final StaffFilter filter;

  const SocietyStaffState({
    this.staffList = const [],
    this.attendance = const {},
    this.filter = StaffFilter.all,
  });

  SocietyStaffState copyWith({
    List<StaffModel>? staffList,
    Map<String, StaffAttendanceStatus>? attendance,
    StaffFilter? filter,
  }) {
    return SocietyStaffState(
      staffList: staffList ?? this.staffList,
      attendance: attendance ?? this.attendance,
      filter: filter ?? this.filter,
    );
  }

  int get totalStaff => staffList.length;

  int get presentCount => staffList.where((staff) {
    return attendance[staff.mobileNumber] ==
        StaffAttendanceStatus.present;
  }).length;

  int get absentCount => totalStaff - presentCount;

  List<StaffModel> get filteredStaff {
    switch (filter) {
      case StaffFilter.present:
        return staffList.where((staff) {
          return attendance[staff.mobileNumber] ==
              StaffAttendanceStatus.present;
        }).toList();

      case StaffFilter.absent:
        return staffList.where((staff) {
          return attendance[staff.mobileNumber] !=
              StaffAttendanceStatus.present;
        }).toList();

      case StaffFilter.all:
        return staffList;
    }
  }
}

class SocietyStaffBloc
    extends Bloc<SocietyStaffEvent, SocietyStaffState> {
  SocietyStaffBloc() : super(const SocietyStaffState()) {
    
    on<AddStaffEvent>((event, emit) {
      final updatedList = [...state.staffList, event.staff];
      final updatedAttendance = Map<String, StaffAttendanceStatus>.from(
        state.attendance,
      );

      updatedAttendance.putIfAbsent(
        event.staff.mobileNumber,
        () => StaffAttendanceStatus.absent,
      );

      emit(state.copyWith(
        staffList: updatedList,
        attendance: updatedAttendance,
      ));
    });

    on<UpdateStaffEvent>((event, emit) {
      final updatedList = state.staffList.map((staff) {
        return staff.mobileNumber == event.staff.mobileNumber
            ? event.staff
            : staff;
      }).toList();

      emit(state.copyWith(staffList: updatedList));
    });

    on<DeleteStaffEvent>((event, emit) {
      final updatedList = state.staffList
          .where((staff) => staff.mobileNumber != event.mobileNumber)
          .toList();

      final updatedAttendance =
          Map<String, StaffAttendanceStatus>.from(state.attendance)
            ..remove(event.mobileNumber);

      emit(state.copyWith(
        staffList: updatedList,
        attendance: updatedAttendance,
      ));
    });

    on<ToggleStaffAttendanceEvent>((event, emit) {
      final updatedAttendance =
          Map<String, StaffAttendanceStatus>.from(state.attendance);

      final currentStatus = updatedAttendance[event.mobileNumber];

      updatedAttendance[event.mobileNumber] =
          currentStatus == StaffAttendanceStatus.present
              ? StaffAttendanceStatus.absent
              : StaffAttendanceStatus.present;

      emit(state.copyWith(attendance: updatedAttendance));
    });

    on<ChangeStaffFilterEvent>((event, emit) {
      emit(state.copyWith(filter: event.filter));
    });
  }
}
