class AuditLogModel {
  final String id;
  final String date;
  final String user;
  final String action;
  final String module;
  final String description;

  const AuditLogModel({
    required this.id,
    required this.date,
    required this.user,
    required this.action,
    required this.module,
    required this.description,
  });
}