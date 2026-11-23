class ComplaintModel {
  final String society;
  final String category;
  final String priority;
  final String title;
  final String description;
  final String resident;
  final String assignedTo;
  final String latestRemark;
  final String status;
  final DateTime createdAt;

  ComplaintModel({
    required this.society,
    required this.category,
    required this.priority,
    required this.title,
    required this.description,
    this.resident = 'Unassigned',
    this.assignedTo = '-',
    this.latestRemark = '-',
    this.status = 'Open',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  ComplaintModel copyWithStatus(String newStatus) {
  return ComplaintModel(
    society: society,
    category: category,
    priority: priority,
    title: title,
    description: description,
    resident: resident,
    assignedTo: assignedTo,
    latestRemark: latestRemark,
    status: newStatus,
    createdAt: createdAt,
  );
}
}