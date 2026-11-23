
import 'package:society_management/Member/VisitorPass/presentation/bloc/VisitorPassModel.dart';

class VisitorPassRepository {
  static final List<VisitorPassModel> _passes = [
    VisitorPassModel(
      society: 'Jainam Heights CHS Ltd',
      visitorName: 'RuchiGuest',
      mobileNumber: '9029830200',
      type: 'Guest',
      resident: 'Unlinked / Walk-in',
      vehicleNumber: '',
      companyService: '',
      expectedAt: DateTime(2026, 12, 4, 14, 2),
      validUntil: DateTime(2026, 12, 4, 18, 0),
      purpose: 'Personal visit',
      status: 'Approved',
      otp: '823601',
    ),
  ];

  Future<List<VisitorPassModel>> getVisitorPasses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_passes);
  }

  Future<VisitorPassModel> createVisitorPass(
    VisitorPassModel visitor,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newPass = visitor.copyWith(
      status: 'Approved',
      otp: (100000 +
              DateTime.now().microsecondsSinceEpoch % 900000)
          .toString(),
    );

    _passes.insert(0, newPass);

    return newPass;
  }
}
