import 'package:flutter_bloc/flutter_bloc.dart';

import 'audit_log_event.dart';
import 'audit_log_model.dart';
import 'audit_log_state.dart';

class AuditLogBloc extends Bloc<AuditLogEvent, AuditLogState> {
  AuditLogBloc() : super(const AuditLogState()) {
    on<AuditLogsLoaded>(_onLogsLoaded);
    on<AuditLogActionChanged>(_onActionChanged);
    on<AuditLogModuleQueryChanged>(_onModuleQueryChanged);
    on<AuditLogSearchSubmitted>(_onSearchSubmitted);
    on<AuditLogPageChanged>(_onPageChanged);

    // Load dummy data initially
    add(AuditLogsLoaded(_dummyAuditLogs));
  }

  static final List<AuditLogModel> _dummyAuditLogs = [
    AuditLogModel(
      id: '1',
      date: '19 Nov 2026, 09:43 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Ledger Master',
      description: 'Created Ledgermaster',
    ),
    AuditLogModel(
      id: '2',
      date: '19 Nov 2026, 06:13 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Users',
      description: 'Created Users',
    ),
    AuditLogModel(
      id: '3',
      date: '19 Nov 2026, 05:14 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Member',
      description: 'Created Member',
    ),
    AuditLogModel(
      id: '4',
      date: '19 Nov 2026, 04:59 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Member',
      description: 'Created Member',
    ),
    AuditLogModel(
      id: '5',
      date: '19 Nov 2026, 03:56 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Users',
      description: 'Created Users',
    ),
    AuditLogModel(
      id: '6',
      date: '19 Nov 2026, 03:56 PM',
      user: 'Jainam',
      action: 'Update',
      module: 'Flats',
      description: 'Updated Flats',
    ),
    AuditLogModel(
      id: '7',
      date: '19 Nov 2026, 03:56 PM',
      user: 'Jainam',
      action: 'Update',
      module: 'Flats',
      description: 'Updated Flats',
    ),
    AuditLogModel(
      id: '8',
      date: '19 Nov 2026, 03:09 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Role',
      description: 'Created Role',
    ),
    AuditLogModel(
      id: '9',
      date: '18 Nov 2026, 05:11 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Staff',
      description: 'Created Staff',
    ),
    AuditLogModel(
      id: '10',
      date: '18 Nov 2026, 05:11 PM',
      user: 'Jainam',
      action: 'Create',
      module: 'Staff',
      description: 'Created Staff',
    ),
    AuditLogModel(
      id: '11',
      date: '18 Nov 2026, 04:30 PM',
      user: 'Jainam',
      action: 'Update',
      module: 'Society',
      description: 'Updated Society Details',
    ),
    AuditLogModel(
      id: '12',
      date: '18 Nov 2026, 03:15 PM',
      user: 'Jainam',
      action: 'Delete',
      module: 'Parking Slot',
      description: 'Deleted Parking Slot',
    ),
    AuditLogModel(
      id: '13',
      date: '17 Nov 2026, 06:20 PM',
      user: 'Admin',
      action: 'Create',
      module: 'Parking Slot',
      description: 'Created Parking Slot',
    ),
    AuditLogModel(
      id: '14',
      date: '17 Nov 2026, 05:45 PM',
      user: 'Jainam',
      action: 'Update',
      module: 'Staff',
      description: 'Updated Staff Details',
    ),
    AuditLogModel(
      id: '15',
      date: '17 Nov 2026, 04:10 PM',
      user: 'Admin',
      action: 'Delete',
      module: 'Member',
      description: 'Deleted Member',
    ),
  ];

  void _onLogsLoaded(
    AuditLogsLoaded event,
    Emitter<AuditLogState> emit,
  ) {
    emit(
      state.copyWith(
        logs: event.logs,
        currentPage: 1,
      ),
    );
  }

  void _onActionChanged(
    AuditLogActionChanged event,
    Emitter<AuditLogState> emit,
  ) {
    emit(
      state.copyWith(
        selectedAction: event.action,
        currentPage: 1,
      ),
    );
  }

  void _onModuleQueryChanged(
    AuditLogModuleQueryChanged event,
    Emitter<AuditLogState> emit,
  ) {
    emit(state.copyWith(moduleInput: event.query));
  }

  void _onSearchSubmitted(
    AuditLogSearchSubmitted event,
    Emitter<AuditLogState> emit,
  ) {
    emit(
      state.copyWith(
        moduleFilter: state.moduleInput,
        currentPage: 1,
      ),
    );
  }

  void _onPageChanged(
    AuditLogPageChanged event,
    Emitter<AuditLogState> emit,
  ) {
    if (event.page < 1 || event.page > state.totalPages) return;

    emit(state.copyWith(currentPage: event.page));
  }
}