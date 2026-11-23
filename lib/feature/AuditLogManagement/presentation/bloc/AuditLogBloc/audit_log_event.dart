import 'audit_log_model.dart';

abstract class AuditLogEvent {}

class AuditLogsLoaded extends AuditLogEvent {
  final List<AuditLogModel> logs;

  AuditLogsLoaded(this.logs);
}

class AuditLogActionChanged extends AuditLogEvent {
  final String action;

  AuditLogActionChanged(this.action);
}

class AuditLogModuleQueryChanged extends AuditLogEvent {
  final String query;

  AuditLogModuleQueryChanged(this.query);
}

class AuditLogSearchSubmitted extends AuditLogEvent {}

class AuditLogPageChanged extends AuditLogEvent {
  final int page;

  AuditLogPageChanged(this.page);
}