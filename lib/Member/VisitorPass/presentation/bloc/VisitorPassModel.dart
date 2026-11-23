
class VisitorPassModel {
  final String society;
  final String visitorName;
  final String mobileNumber;
  final String type;
  final String resident;
  final String vehicleNumber;
  final String companyService;
  final DateTime expectedAt;
  final DateTime validUntil;
  final String purpose;
  final String status;
  final String otp;

  VisitorPassModel({
    required this.society,
    required this.visitorName,
    required this.mobileNumber,
    required this.type,
    required this.resident,
    required this.vehicleNumber,
    required this.companyService,
    required this.expectedAt,
    required this.validUntil,
    required this.purpose,
    this.status = 'Approved',
    this.otp = '823601',
  });

  VisitorPassModel copyWith({
    String? society,
    String? visitorName,
    String? mobileNumber,
    String? type,
    String? resident,
    String? vehicleNumber,
    String? companyService,
    DateTime? expectedAt,
    DateTime? validUntil,
    String? purpose,
    String? status,
    String? otp,
  }) {
    return VisitorPassModel(
      society: society ?? this.society,
      visitorName: visitorName ?? this.visitorName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      type: type ?? this.type,
      resident: resident ?? this.resident,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      companyService: companyService ?? this.companyService,
      expectedAt: expectedAt ?? this.expectedAt,
      validUntil: validUntil ?? this.validUntil,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      otp: otp ?? this.otp,
    );
  }
}
