
import 'package:society_management/feature/Financial/presentation/bloc/FinancialMonthModel.dart';
import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/HeadModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/NonMemberModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';

abstract class SocietySetupEvent {}

class SocietyInformationSubmitted extends SocietySetupEvent {
  final String societyName;
  final String address;
  final String pincode;
  final String city;
  final String state;
  final String registrationNumber;
  final String panNumber;

  SocietyInformationSubmitted({
    required this.societyName,
    required this.address,
    required this.pincode,
    required this.city,
    required this.state,
    required this.registrationNumber,
    required this.panNumber,
  });
}

class SocietySetupStepChanged extends SocietySetupEvent {
  final int step;

  SocietySetupStepChanged(this.step);
}


class BankAccountAdded extends SocietySetupEvent {
  final BankAccountModel account;

  BankAccountAdded(this.account);
}

class BankAccountRemoved extends SocietySetupEvent {
  final int index;

  BankAccountRemoved(this.index);
}
class BankDetailsSubmitted extends SocietySetupEvent {}class WingNamesAdded extends SocietySetupEvent {
  final List<String> wings;

  WingNamesAdded(this.wings);
}

class WingRemoved extends SocietySetupEvent {
  final String wing;

  WingRemoved(this.wing);
}

class WingSetupSubmitted extends SocietySetupEvent {}

class WingSetupSkipped extends SocietySetupEvent {}
class FlatsRangeAdded extends SocietySetupEvent {
  final List<FlatModel> flats;

  FlatsRangeAdded(this.flats);
}

class FlatRemoved extends SocietySetupEvent {
  final int index;

  FlatRemoved(this.index);
}

class FlatSetupSubmitted extends SocietySetupEvent {}

class FlatSetupSkipped extends SocietySetupEvent {}

class PreviousStepPressed extends SocietySetupEvent {}

class NonMemberAdded extends SocietySetupEvent {
  final NonMemberModel nonMember;

  NonMemberAdded(this.nonMember);
}

class NonMemberRemoved extends SocietySetupEvent {
  final int index;

  NonMemberRemoved(this.index);
}

class NonMemberSetupSubmitted extends SocietySetupEvent {}

class NonMemberSetupSkipped extends SocietySetupEvent {}


class HeadAdded extends SocietySetupEvent {
  final HeadModel head;

  HeadAdded(this.head);
}

class HeadRemoved extends SocietySetupEvent {
  final int index;

  HeadRemoved(this.index);
}

class HeadSetupSubmitted extends SocietySetupEvent {}
class MemberSetupSubmitted extends SocietySetupEvent {}

class FinancialYearSetupSubmitted extends SocietySetupEvent {}



class ExpenseMasterSubmitted extends SocietySetupEvent {}

class BillingConfigurationSubmitted extends SocietySetupEvent {}
class FinancialMonthAdded extends SocietySetupEvent {
  final FinancialMonthModel financialMonth;

  FinancialMonthAdded(this.financialMonth);

  @override
  List<Object?> get props => [financialMonth];
}

class FinancialMonthRemoved extends SocietySetupEvent {
  final int index;

  FinancialMonthRemoved(this.index);

  @override
  List<Object?> get props => [index];
}