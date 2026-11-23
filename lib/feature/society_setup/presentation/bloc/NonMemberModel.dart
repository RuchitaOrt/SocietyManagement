class NonMemberModel {
  final String name;
  final String contactNumber;
  final String email;
  final String financialYear;
  final String addressLine1;
  final String addressLine2;
  final String aadhaarNumber;
  final String panNumber;
  final String? aadhaarAttachment;
  final String? panAttachment;
  final String? policeNocAttachment;

  NonMemberModel({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.financialYear,
    required this.addressLine1,
    required this.addressLine2,
    required this.aadhaarNumber,
    required this.panNumber,
     this.aadhaarAttachment,
     this.panAttachment,
    this.policeNocAttachment,
  });
}