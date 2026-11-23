class StaffModel {
  final String fullName;
  final String mobileNumber;
  final String address;
  final String category;
  final DateTime joiningDate;
  final String wing;
  final List<String> assignedFlats;
  final String aadhaarNumber;
  final String? staffPhotoPath;
  final String? aadhaarDocumentPath;
  final String notes;

  StaffModel({
    required this.fullName,
    required this.mobileNumber,
    required this.address,
    required this.category,
    required this.joiningDate,
    required this.wing,
    required this.assignedFlats,
    required this.aadhaarNumber,
    this.staffPhotoPath,
    this.aadhaarDocumentPath,
    required this.notes,
  });
}