
import 'package:society_management/feature/Financial/presentation/bloc/FinancialMonthModel.dart';
import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/FinancialYearModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/HeadModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/NonMemberModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';

class SocietySetupState {
  final int currentStep;
  final Set<int> completedSteps;

  final String societyName;
  final String address;
  final String pincode;
  final String city;
  final String state;
  final String registrationNumber;
  final String panNumber;
  final List<BankAccountModel> bankAccounts;
  final List<String> wings;
  final List<FlatModel> flats;
  final List<FinancialYearModel> financialYears;
  final List<NonMemberModel> nonMembers;
  final List<HeadModel> heads;
  final List<FinancialMonthModel> financialMonths;

  const SocietySetupState({
    this.currentStep = 0,
    this.completedSteps = const {},
    this.societyName = '',
    this.address = '',
    this.pincode = '',
    this.city = '',
    this.state = '',
    this.registrationNumber = '',
    this.panNumber = '',
    this.bankAccounts = const [],
    this.wings = const [],
    this.flats = const [],
    this.financialYears = const [],
    this.nonMembers = const [],
    this.heads = const [],
    this.financialMonths=const [],
  });

  SocietySetupState copyWith({
    int? currentStep,
    Set<int>? completedSteps,
    String? societyName,
    String? address,
    String? pincode,
    String? city,
    String? state,
    String? registrationNumber,
    String? panNumber,
    List<BankAccountModel>? bankAccounts,
    List<String>? wings,
     List<FlatModel>? flats,
     List<FinancialYearModel>? financialYears,
     List<NonMemberModel>? nonMembers,
     List<HeadModel>? heads,
     final List<FinancialMonthModel>? financialMonths
  }) {
    return SocietySetupState(
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      societyName: societyName ?? this.societyName,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      state: state ?? this.state,
      registrationNumber:
          registrationNumber ?? this.registrationNumber,
      panNumber: panNumber ?? this.panNumber,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      wings: wings ?? this.wings,
       flats: flats ?? this.flats,
       financialYears: financialYears ?? this.financialYears,
       nonMembers: nonMembers ?? this.nonMembers,
       heads: heads ?? this.heads,
        financialMonths: financialMonths ?? this.financialMonths,
    );
  }
  @override
List<Object?> get props => [
  // Existing properties
  flats,
];
}



