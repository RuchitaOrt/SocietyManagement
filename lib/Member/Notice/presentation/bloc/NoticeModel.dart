class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String createdAt;
  final bool isRead;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    this.isRead = false,
  });

  NoticeModel copyWith({bool? isRead}) {
    return NoticeModel(
      id: id,
      title: title,
      description: description,
      category: category,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}