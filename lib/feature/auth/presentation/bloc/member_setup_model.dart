class MemberSetupModel {
  final String society;
  final String designation;
  final String ownerName;
  final String email;
  final String contact;
  final String dob;
  final String panNumber;
  final String aadhaarNumber;
  final String wing;
  final String flatNumber;
  final String address;
  final List<String> nominees;
  final List<String> coOwners;

  MemberSetupModel({
    required this.society,
    required this.designation,
    required this.ownerName,
    required this.email,
    required this.contact,
    required this.dob,
    required this.panNumber,
    required this.aadhaarNumber,
    required this.wing,
    required this.flatNumber,
    required this.address,
    required this.nominees,
    required this.coOwners,
  });
}