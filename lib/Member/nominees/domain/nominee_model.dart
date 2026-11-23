
class NomineeModel {
  final String id;
  final String name;
  final String relationship;
  final String mobile;
  final String date;
  final bool isActive;

  const NomineeModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.mobile,
    required this.date,
    this.isActive = true,
  });
}
