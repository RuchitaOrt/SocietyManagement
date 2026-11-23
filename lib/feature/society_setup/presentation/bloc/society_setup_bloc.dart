
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society_management/feature/Financial/presentation/bloc/FinancialMonthModel.dart';

import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/FinancialYearModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/NonMemberModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';

import 'society_setup_event.dart';
import 'society_setup_state.dart';

class SocietySetupBloc
    extends Bloc<SocietySetupEvent, SocietySetupState> {
  SocietySetupBloc() : super(const SocietySetupState()) {
    on<SocietyInformationSubmitted>(_onSocietyInformationSubmitted);
    on<SocietySetupStepChanged>(_onStepChanged);
    on<FinancialYearAdded>(_onFinancialYearAdded);
    on<FinancialYearSetupSubmitted>((event, emit) {
  if (state.financialYears.isEmpty) return;

  emit(
    state.copyWith(
      completedSteps: {
        ...state.completedSteps,
        5,
      },
      currentStep: 6,
    ),
  );
});

on<NonMemberSetupSubmitted>((event, emit) {
  if (state.nonMembers.isEmpty) return;

  emit(
    state.copyWith(
      completedSteps: {
        ...state.completedSteps,
        6,
      },
      currentStep: 7,
    ),
  );
});

on<ExpenseMasterSubmitted>((event, emit) {
  emit(
    state.copyWith(
      completedSteps: {
        ...state.completedSteps,
        8,
      },
      currentStep: 9,
    ),
  );
});

on<BillingConfigurationSubmitted>((event, emit) {
  emit(
    state.copyWith(
      completedSteps: {
        ...state.completedSteps,
        9,
      },
    ),
  );
});
    on<MemberSetupSubmitted>((event, emit) {
  final updatedSteps = Set<int>.from(state.completedSteps);

  updatedSteps.add(4);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 5,
    ),
  );
});
    on<NonMemberAdded>((event, emit) {
  emit(
    state.copyWith(
      nonMembers: [
        ...state.nonMembers,
        event.nonMember,
      ],
    ),
  );
});
on<HeadAdded>((event, emit) {
  emit(
    state.copyWith(
      heads: [
        ...state.heads,
        event.head,
      ],
    ),
  );
});

on<HeadRemoved>((event, emit) {
  if (event.index < 0 ||
      event.index >= state.heads.length) {
    return;
  }

  final updatedHeads = List.of(state.heads)
    ..removeAt(event.index);

  emit(
    state.copyWith(
      heads: updatedHeads,
    ),
  );
});

on<HeadSetupSubmitted>((event, emit) {
  if (state.heads.isEmpty) return;

  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(7);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 8,
    ),
  );
});
on<NonMemberRemoved>((event, emit) {
  if (event.index < 0 ||
      event.index >= state.nonMembers.length) {
    return;
  }

  final updatedList = List<NonMemberModel>.from(
    state.nonMembers,
  );

  updatedList.removeAt(event.index);

  emit(
    state.copyWith(
      nonMembers: updatedList,
    ),
  );
});


on<NonMemberSetupSkipped>((event, emit) {
  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(6);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 7,
    ),
  );
});
on<FinancialYearRemoved>(_onFinancialYearRemoved);
  on<FlatsRangeAdded>((event, emit) {
  emit(
    state.copyWith(
      flats: [
        ...state.flats,
        ...event.flats,
      ],
    ),
  );
});
    on<PreviousStepPressed>((event, emit) {
  if (state.currentStep > 0) {
    emit(
      state.copyWith(
        currentStep: state.currentStep - 1,
      ),
    );
  }
});
  

on<FlatRemoved>((event, emit) {
  if (event.index < 0 || event.index >= state.flats.length) {
    return;
  }

  final updatedFlats = List<FlatModel>.from(state.flats)
    ..removeAt(event.index);

  emit(state.copyWith(flats: updatedFlats));
});

on<FlatSetupSubmitted>((event, emit) {
  emit(state.copyWith(
    completedSteps: {
      ...state.completedSteps,
      3,
    },
    currentStep: 4,
  ));
});
on<FlatSetupSkipped>((event, emit) {
  final completed = Set<int>.from(state.completedSteps)..add(3);

  emit(state.copyWith(
    completedSteps: completed,
    currentStep: 4,
  ));
});
    on<WingNamesAdded>((event, emit) {
  final updatedWings = List<String>.from(state.wings);

  for (final wing in event.wings) {
    final alreadyExists = updatedWings.any(
      (existing) =>
          existing.toLowerCase() == wing.toLowerCase(),
    );

    if (!alreadyExists) {
      updatedWings.add(wing);
    }
  }

  emit(state.copyWith(wings: updatedWings));
});
on<FinancialMonthAdded>((event, emit) {
  final updatedMonths = List<FinancialMonthModel>.from(
    state.financialMonths,
  )..add(event.financialMonth);

  emit(state.copyWith(
    financialMonths: updatedMonths,
  ));
});

on<FinancialMonthRemoved>((event, emit) {
  final updatedMonths = List<FinancialMonthModel>.from(
    state.financialMonths,
  );

  if (event.index < 0 || event.index >= updatedMonths.length) {
    return;
  }

  updatedMonths.removeAt(event.index);

  emit(state.copyWith(
    financialMonths: updatedMonths,
  ));
});
on<WingRemoved>((event, emit) {
  final updatedWings = List<String>.from(state.wings)
    ..removeWhere(
      (wing) => wing == event.wing,
    );

  emit(state.copyWith(wings: updatedWings));
});

on<WingSetupSubmitted>((event, emit) {
  if (state.wings.isEmpty) return;

  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(2);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 3,
    ),
  );
});

on<WingSetupSkipped>((event, emit) {
  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(2);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 3,
    ),
  );
});
on<BankDetailsSubmitted>((event, emit) {
  if (state.bankAccounts.isEmpty) return;

  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(1);

  emit(
    state.copyWith(
      completedSteps: updatedSteps,
      currentStep: 2,
    ),
  );
});
on<BankAccountAdded>((event, emit) {
  final accounts = List<BankAccountModel>.from(
    state.bankAccounts,
  );

  // Only one account can be the default account.
  if (event.account.isDefault) {
    for (int i = 0; i < accounts.length; i++) {
      accounts[i] = accounts[i].copyWith(isDefault: false);
    }
  }

  accounts.add(event.account);

  emit(
    state.copyWith(
      bankAccounts: accounts,
    ),
  );
});

on<BankAccountRemoved>((event, emit) {
  if (event.index < 0 ||
      event.index >= state.bankAccounts.length) {
    return;
  }

  final accounts = List<BankAccountModel>.from(
    state.bankAccounts,
  );

  final wasDefault = accounts[event.index].isDefault;
  accounts.removeAt(event.index);

  if (wasDefault && accounts.isNotEmpty) {
    accounts[0] = accounts[0].copyWith(isDefault: true);
  }

  emit(
    state.copyWith(
      bankAccounts: accounts,
    ),
  );
});

  }

  void _onSocietyInformationSubmitted(
  SocietyInformationSubmitted event,
  Emitter<SocietySetupState> emit,
) {
  debugPrint('========== STEP 1 SAVING ==========');
  debugPrint('Society: ${event.societyName}');
  debugPrint('Address: ${event.address}');
  debugPrint('City: ${event.city}');
  debugPrint('State: ${event.state}');
  debugPrint('Pincode: ${event.pincode}');
  debugPrint('Registration: ${event.registrationNumber}');
  debugPrint('PAN: ${event.panNumber}');

  final updatedSteps = Set<int>.from(state.completedSteps)
    ..add(0);

  emit(
    state.copyWith(
      societyName: event.societyName,
      address: event.address,
      pincode: event.pincode,
      city: event.city,
      state: event.state,
      registrationNumber: event.registrationNumber,
      panNumber: event.panNumber,
      completedSteps: updatedSteps,
      currentStep: 1,
    ),
  );
}
void _onFinancialYearAdded(
  FinancialYearAdded event,
  Emitter<SocietySetupState> emit,
) {
  final updatedYears = [
    ...state.financialYears,
    event.financialYear,
  ];

  emit(
    state.copyWith(
      financialYears: updatedYears,
    ),
  );
}

void _onFinancialYearRemoved(
  FinancialYearRemoved event,
  Emitter<SocietySetupState> emit,
) {
  final updatedFinancialYears = List.of(state.financialYears);

  if (event.index < 0 ||
      event.index >= updatedFinancialYears.length) {
    return;
  }

  updatedFinancialYears.removeAt(event.index);

  emit(
    state.copyWith(
      financialYears: updatedFinancialYears,
    ),
  );
}
void _onStepChanged(
  SocietySetupStepChanged event,
  Emitter<SocietySetupState> emit,
) {
  if (event.step < 0 || event.step > 9) return;

  emit(
    state.copyWith(
      currentStep: event.step,
    ),
  );
}
}



class FinancialYearAdded extends SocietySetupEvent {
  final FinancialYearModel financialYear;

  FinancialYearAdded(this.financialYear);
}
class FinancialYearRemoved extends SocietySetupEvent {
  final int index;

   FinancialYearRemoved(this.index);
}
