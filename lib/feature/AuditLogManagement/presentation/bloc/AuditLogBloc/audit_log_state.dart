import 'audit_log_model.dart';

class AuditLogState {
  final List<AuditLogModel> logs;
  final String selectedAction;
  final String moduleInput;
  final String moduleFilter;
  final int currentPage;

  static const int pageSize = 10;

  const AuditLogState({
    this.logs = const [],
    this.selectedAction = 'All actions',
    this.moduleInput = '',
    this.moduleFilter = '',
    this.currentPage = 1,
  });

  List<AuditLogModel> get filteredLogs {
    return logs.where((log) {
      final actionMatches = selectedAction == 'All actions' ||
          log.action.toLowerCase() == selectedAction.toLowerCase();

      final moduleMatches = moduleFilter.trim().isEmpty ||
          log.module.toLowerCase().contains(
                moduleFilter.trim().toLowerCase(),
              );

      return actionMatches && moduleMatches;
    }).toList();
  }

  int get totalLogs => logs.length;

  int get createCount => logs
      .where((e) => e.action.toLowerCase() == 'create')
      .length;

  int get updateCount => logs
      .where((e) => e.action.toLowerCase() == 'update')
      .length;

  int get deleteCount => logs
      .where((e) => e.action.toLowerCase() == 'delete')
      .length;

  int get totalPages =>
      filteredLogs.isEmpty ? 1 : (filteredLogs.length / pageSize).ceil();

  List<AuditLogModel> get paginatedLogs {
    final start = (currentPage - 1) * pageSize;

    if (start >= filteredLogs.length) return [];

    final end = (start + pageSize).clamp(0, filteredLogs.length);

    return filteredLogs.sublist(start, end);
  }

  AuditLogState copyWith({
    List<AuditLogModel>? logs,
    String? selectedAction,
    String? moduleInput,
    String? moduleFilter,
    int? currentPage,
  }) {
    return AuditLogState(
      logs: logs ?? this.logs,
      selectedAction: selectedAction ?? this.selectedAction,
      moduleInput: moduleInput ?? this.moduleInput,
      moduleFilter: moduleFilter ?? this.moduleFilter,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}