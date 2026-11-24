import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:society_management/core/constants/AppTextSizes.dart';
import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/feature/admin/presentation/screens/admin_main_screen.dart';

import 'package:society_management/feature/auth/presentation/bloc/flat_model.dart';
import 'package:society_management/feature/auth/presentation/bloc/member_setup_model.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/ExpenseCategoryModel.dart';
import 'package:society_management/feature/society_setup/presentation/bloc/bank_account_model.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/BaiscInfor.dart/society_information_form.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/BankInfo/add_bank_bottom_sheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/BankInfo/bank_accounts_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/BillingRules/billing_configuration_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/ExpenseMasterScreen/add_expense_category_dialog.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/ExpenseMasterScreen/expense_master_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/FlatSetup/flat_setup_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/FlatSetup/showAddFlatRangeBottomSheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/HaedMaster/add_head_bottom_sheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/HaedMaster/head_setup_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/MemberSetup/member_setup_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/MemberSetup/showAddMemberBottomSheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/NonMembersetup.dart/add_non_member_dialog.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/NonMembersetup.dart/non_member_setup_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/WingsSetup/add_wings_dialog.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/WingsSetup/wing_setup_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/financial_year/add_financial_year_bottom_sheet.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/financial_year/financial_year_section.dart';
import 'package:society_management/feature/society_setup/presentation/widgets/showSetupStepsSheet.dart';

import '../bloc/society_setup_bloc.dart';
import '../bloc/society_setup_event.dart';
import '../bloc/society_setup_state.dart';

class SocietySetupScreen extends StatelessWidget {
  final bool isEditMode;

  const SocietySetupScreen({super.key, this.isEditMode = false});

  @override
  Widget build(BuildContext context) {
    return SocietySetupView(isEditMode: isEditMode);
  }
}

class SocietySetupView extends StatefulWidget {
  final bool isEditMode;

  const SocietySetupView({super.key, this.isEditMode = false});

  @override
  State<SocietySetupView> createState() => _SocietySetupViewState();
}

class _SocietySetupViewState extends State<SocietySetupView> {
  final _formKey = GlobalKey<FormState>();
  bool get isEditMode => widget.isEditMode;
  final societyNameController = TextEditingController(text: 'Jainam Heights');
  final addressController = TextEditingController(text: 'Andheri West, Mumbai');
  final pincodeController = TextEditingController(text: '400058');
  final cityController = TextEditingController(text: 'Mumbai');
  final stateController = TextEditingController(text: 'Maharashtra');
  final registrationController = TextEditingController(text: 'SOC/2026/001');
  final panController = TextEditingController(text: 'AAAAA0000A');

  final List<MemberSetupModel> _members = [
    // MemberSetupModel(
    //   society: 'Green Valley Residency',
    //   designation: 'Owner',
    //   ownerName: 'Rahul Sharma',
    //   email: 'rahul.sharma@gmail.com',
    //   contact: '9876543210',
    //   dob: '15-05-1985',
    //   panNumber: 'ABCDE1234F',
    //   aadhaarNumber: '123456789012',
    //   wing: 'A',
    //   flatNumber: '101',
    //   address: 'Mumbai, Maharashtra',
    //   nominees: ['Priya Sharma'],
    //   coOwners: [],
    // ),
    // MemberSetupModel(
    //   society: 'Green Valley Residency',
    //   designation: 'Owner',
    //   ownerName: 'Priya Patel',
    //   email: 'priya.patel@gmail.com',
    //   contact: '9876543211',
    //   dob: '20-08-1990',
    //   panNumber: 'FGHIJ5678K',
    //   aadhaarNumber: '234567890123',
    //   wing: 'A',
    //   flatNumber: '102',
    //   address: 'Mumbai, Maharashtra',
    //   nominees: ['Amit Patel'],
    //   coOwners: ['Amit Patel'],
    // ),
    // MemberSetupModel(
    //   society: 'Green Valley Residency',
    //   designation: 'Tenant',
    //   ownerName: 'Amit Deshmukh',
    //   email: 'amit.deshmukh@gmail.com',
    //   contact: '9876543212',
    //   dob: '10-12-1988',
    //   panNumber: 'KLMNO1234P',
    //   aadhaarNumber: '345678901234',
    //   wing: 'A',
    //   flatNumber: '103',
    //   address: 'Mumbai, Maharashtra',
    //   nominees: [],
    //   coOwners: [],
    // ),
    // MemberSetupModel(
    //   society: 'Green Valley Residency',
    //   designation: 'Owner',
    //   ownerName: 'Sneha Kulkarni',
    //   email: 'sneha.kulkarni@gmail.com',
    //   contact: '9876543213',
    //   dob: '25-03-1992',
    //   panNumber: 'PQRST5678U',
    //   aadhaarNumber: '456789012345',
    //   wing: 'B',
    //   flatNumber: '101',
    //   address: 'Mumbai, Maharashtra',
    //   nominees: ['Vikas Kulkarni'],
    //   coOwners: ['Vikas Kulkarni'],
    // ),
    // MemberSetupModel(
    //   society: 'Green Valley Residency',
    //   designation: 'Owner',
    //   ownerName: 'Vikas Mehta',
    //   email: 'vikas.mehta@gmail.com',
    //   contact: '9876543214',
    //   dob: '08-07-1982',
    //   panNumber: 'UVWXY1234Z',
    //   aadhaarNumber: '567890123456',
    //   wing: 'B',
    //   flatNumber: '102',
    //   address: 'Mumbai, Maharashtra',
    //   nominees: [],
    //   coOwners: [],
    // ),
  ];
  @override
  void initState() {
    super.initState();

    final state = context.read<SocietySetupBloc>().state;

    societyNameController.text = state.societyName;
    addressController.text = state.address;
    pincodeController.text = state.pincode;
    cityController.text = state.city;
    stateController.text = state.state;
    registrationController.text = state.registrationNumber;
    panController.text = state.panNumber;
  }

  final List<ExpenseCategoryModel> _expenseCategories = [];
  bool _hasNavigated = false;
  Future<void> _showAddExpenseCategory() async {
    final result = await showAddExpenseCategoryBottomSheet(
      context: context,
      accountGroups: const [],
    );

    if (!mounted || result == null) return;

    // Prevent duplicate expense codes.
    final alreadyExists = _expenseCategories.any(
      (category) =>
          category.expenseCode.toUpperCase() ==
          result.expenseCode.toUpperCase(),
    );

    if (alreadyExists) {
      _showMessage('Expense code already exists.');
      return;
    }

    setState(() {
      _expenseCategories.add(result);
    });
  }

  static const Color primaryColor = Color(0xFFE93691);
  static const Color backgroundColor = Color(0xFFF5F7FB);
  static const Color textColor = Color(0xFF202B43);
  static const Color hintColor = Color(0xFF91A0B8);

  final List<String> steps = [
    'Society Information',
    'Bank Details',
    'Wing Setup',
    'Flat Setup',
    'Member Setup',
    'Financial Year',
    'Non-Member Setup',
    'Heads Master',
    'Expense Master',
    'Billing Configuration',
  ];

  @override
  void dispose() {
    societyNameController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    registrationController.dispose();
    panController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    if (_formKey.currentState?.validate() != true) return;

    context.read<SocietySetupBloc>().add(
      SocietyInformationSubmitted(
        societyName: societyNameController.text.trim(),
        address: addressController.text.trim(),
        pincode: pincodeController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        registrationNumber: registrationController.text.trim(),
        panNumber: panController.text.trim().toUpperCase(),
      ),
    );
  }

void _updateDetails(SocietySetupState state) {
  switch (state.currentStep) {
    case 0:
      if (_formKey.currentState?.validate() != true) return;

      context.read<SocietySetupBloc>().add(
        SocietyInformationSubmitted(
          societyName: societyNameController.text.trim(),
          address: addressController.text.trim(),
          pincode: pincodeController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          registrationNumber: registrationController.text.trim(),
          panNumber: panController.text.trim().toUpperCase(),
        ),
      );
      return;

    case 1:
      if (state.bankAccounts.isEmpty) {
        _showMessage('Please add at least one bank account');
        return;
      }
      break;

    case 2:
      if (state.wings.isEmpty) {
        _showMessage('Please add at least one wing');
        return;
      }
      break;

    case 3:
      if (state.flats.isEmpty) {
        _showMessage('Please add at least one flat');
        return;
      }
      break;

    case 4:
      if (_members.isEmpty) {
        _showMessage('Please add at least one member');
        return;
      }
      break;

    case 5:
      if (state.financialYears.isEmpty) {
        _showMessage('Please add at least one financial year');
        return;
      }
      break;

    case 6:
      if (state.nonMembers.isEmpty) {
        _showMessage('Please add at least one non-member');
        return;
      }
      break;

    case 7:
      if (state.heads.isEmpty) {
        _showMessage('Please add at least one head');
        return;
      }
      break;

    case 8:
      if (_expenseCategories.isEmpty) {
        _showMessage('Please add at least one expense category');
        return;
      }
      break;

    case 9:
      // Billing configuration update.
      // Add validation here if your billing section has required fields.
      break;

    default:
      return;
  }

  _goToDashboard();
}
  void _goToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AdminMainScreen()),
      (route) => false,
    );
  }

  Future<void> _showAddBankSheet() async {
    final bank = await showAddBankBottomSheet(context);

    if (!mounted || bank == null) return;

    context.read<SocietySetupBloc>().add(BankAccountAdded(bank));
  }

  Future<void> _showAddWingsDialog() async {
    final result = await showAddWingsDialog(context);

    if (!mounted || result == null) return;

    context.read<SocietySetupBloc>().add(WingNamesAdded(result));
  }

  Future<void> _showAddFlatRangeDialog() async {
    final bloc = context.read<SocietySetupBloc>();

    final result = await showAddFlatRangeBottomSheet(
      context: context,
      wings: bloc.state.wings,
    );

    if (!mounted || result == null || result.isEmpty) return;

    bloc.add(FlatsRangeAdded(result));
  }

  Future<void> _showAddMember() async {
    final state = context.read<SocietySetupBloc>().state;

    final flats = state.flats
        .map((flat) => flat.flatNumber.toString())
        .toList();

    if (flats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add flats before adding members.'),
        ),
      );
      return;
    }

    final result = await showAddMemberBottomSheet(
      context: context,
      societyName: societyNameController.text,
      flats: flats,
    );

    if (!mounted || result == null) return;

    setState(() {
      _members.add(result);
    });
  }

  void _showSteps(SocietySetupState state) {
    showSetupStepsSheet(context: context, state: state, steps: steps);
  }

  Widget _buildCurrentStep(SocietySetupState state) {
    switch (state.currentStep) {
      case 0:
        return SocietyInformationForm(
          formKey: _formKey,
          societyNameController: societyNameController,
          addressController: addressController,
          pincodeController: pincodeController,
          cityController: cityController,
          stateController: stateController,
          registrationController: registrationController,
          panController: panController,
        );

      case 1:
        return BankAccountsSection(
          accounts: state.bankAccounts,
          onRemove: (index) {
            context.read<SocietySetupBloc>().add(BankAccountRemoved(index));
          },
        );

      case 2:
        return WingSetupSection(
          wings: state.wings,
          onRemove: (wing) {
            context.read<SocietySetupBloc>().add(WingRemoved(wing));
          },
        );

      case 3:
        return FlatSetupSection(
          flats: state.flats,
          onRemove: (index) {
            context.read<SocietySetupBloc>().add(FlatRemoved(index));
          },
        );

      case 4:
        return MemberSetupSection(
          members: _members,
          onRemove: (index) {
            setState(() {
              _members.removeAt(index);
            });
          },
        );

      case 5:
        return FinancialYearSection(
          financialYears: state.financialYears,
          onRemove: (index) {
            context.read<SocietySetupBloc>().add(FinancialYearRemoved(index));
          },
        );
      case 6:
        return NonMemberSetupSection(
          nonMembers: state.nonMembers,
          onRemove: (index) {
            context.read<SocietySetupBloc>().add(NonMemberRemoved(index));
          },
        );
      case 7:
        return HeadSetupSection(
          heads: state.heads,
          onRemove: (index) {
            context.read<SocietySetupBloc>().add(HeadRemoved(index));
          },
        );

      case 8:
        return ExpenseMasterSection(
          categories: _expenseCategories,
          onRemove: (index) {
            setState(() {
              _expenseCategories.removeAt(index);
            });
          },
        );

      case 9:
        return const BillingConfigurationSection();

      default:
        return _nextStepPlaceholder();
    }
  }

  Future<void> _showAddNonMember() async {
    final result = await showAddNonMemberDialog(context);

    if (!mounted || result == null) return;

    context.read<SocietySetupBloc>().add(NonMemberAdded(result));
  }

  Widget _nextStepPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: 'Coming Soon',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          SizedBox(height: 8),
          CommonText(
            text: 'This setup section will be available in the next step.',
            fontSize: 13,
            color: hintColor,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingButton(SocietySetupState state) {
    switch (state.currentStep) {
      case 1:
        return FloatingActionButton.extended(
          onPressed: _showAddBankSheet,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Bank'),
        );

      case 2:
        return FloatingActionButton.extended(
          onPressed: _showAddWingsDialog,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add New Wing'),
        );

      case 3:
        return FloatingActionButton.extended(
          onPressed: _showAddFlatRangeDialog,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add New Flats'),
        );

      case 4:
        return FloatingActionButton.extended(
          onPressed: _showAddMember,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('Add New Member'),
        );

      case 5:
        return FloatingActionButton.extended(
          onPressed: _showAddFinancialYearDialog,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Financial Year'),
        );
      case 6:
        return FloatingActionButton.extended(
          onPressed: _showAddNonMember,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add New Non-Member'),
        );
      case 7:
        return FloatingActionButton.extended(
          onPressed: _showAddHead,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Head'),
        );
      case 8:
        return FloatingActionButton.extended(
          onPressed: _showAddExpenseCategory,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Expense Category'),
        );
      default:
        return null;
    }
  }

  Future<void> _showAddHead() async {
    final result = await showAddHeadBottomSheet(context: context);

    if (!mounted || result == null) return;

    context.read<SocietySetupBloc>().add(HeadAdded(result));
  }

  Future<void> _handleNext(SocietySetupState state) async {
    final bloc = context.read<SocietySetupBloc>();

    switch (state.currentStep) {
      case 0:
        _saveAndNext();
        break;

      case 1:
        if (state.bankAccounts.isEmpty) {
          _showMessage('Please add at least one bank account');
          return;
        }
        bloc.add(BankDetailsSubmitted());
        break;

      case 2:
        if (state.wings.isEmpty) {
          bloc.add(WingSetupSkipped());
        } else {
          bloc.add(WingSetupSubmitted());
        }
        break;

      case 3:
        if (state.flats.isEmpty) {
          _showMessage('Please add at least one flat');
          return;
        }
        bloc.add(FlatSetupSubmitted());
        break;

      case 4:
        if (_members.isEmpty) {
          _showMessage('Please add at least one member');
          return;
        }
        bloc.add(MemberSetupSubmitted());
        break;

      case 5:
        if (state.financialYears.isEmpty) {
          _showMessage('Please add at least one financial year');
          return;
        }
        bloc.add(FinancialYearSetupSubmitted());
        break;

      case 6:
        if (state.nonMembers.isEmpty) {
          _showMessage('Please add a non-member or skip this step');
          return;
        }
        bloc.add(NonMemberSetupSubmitted());
        break;

      case 7:
        if (state.heads.isEmpty) {
          _showMessage('Please add at least one head');
          return;
        }
        bloc.add(HeadSetupSubmitted());
        break;

      case 8:
        if (_expenseCategories.isEmpty) {
          _showMessage('Please add at least one expense category');
          return;
        }
        bloc.add(ExpenseMasterSubmitted());
        break;
    }
  }
  //   Future<void> _handleNext(SocietySetupState state) async {
  //     final bloc = context.read<SocietySetupBloc>();

  //     if (state.currentStep == 0) {
  //       _saveAndNext();
  //     } else if (state.currentStep == 1) {
  //       if (state.bankAccounts.isEmpty) {
  //         _showMessage('Please add at least one bank account');
  //         return;
  //       }

  //       bloc.add(BankDetailsSubmitted());
  //     } else if (state.currentStep == 2) {
  //       if (state.wings.isEmpty) {
  //         bloc.add(WingSetupSkipped());
  //       } else {
  //         bloc.add(WingSetupSubmitted());
  //       }
  //     } else if (state.currentStep == 3) {
  //       if (state.flats.isEmpty) {
  //         _showMessage('Please add at least one flat');
  //         return;
  //       }

  //       bloc.add(FlatSetupSubmitted());
  //     }  else if (state.currentStep == 4) {
  //   if (_members.isEmpty) {
  //     _showMessage('Please add at least one member');
  //     return;
  //   }

  //   bloc.add(MemberSetupSubmitted());
  // }else if (state.currentStep == 5) {
  //       if (bloc.state.financialYears.isEmpty) {
  //         _showMessage('Please add at least one financial year');
  //         return;
  //       }

  //       bloc.add(SocietySetupStepChanged(6));
  //     } else if (state.currentStep == 6) {
  //       bloc.add(NonMemberSetupSubmitted());
  //     } else if (state.currentStep == 7) {
  //       if (state.heads.isEmpty) {
  //         _showMessage('Please add at least one head');
  //         return;
  //       }

  //       bloc.add(HeadSetupSubmitted());
  //     } else if (state.currentStep == 8) {
  //   // Validate and save Expense Master here.
  //   bloc.add(SocietySetupStepChanged(9));
  // }
  //   }

  void _skipNonMemberStep() {
    context.read<SocietySetupBloc>().add(NonMemberSetupSkipped());
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _completeSetup() {
    context.read<SocietySetupBloc>().add(BillingConfigurationSubmitted());
  }
  // void _completeSetup() {
  //   // TODO: Submit all society setup data to your API
  //   // and navigate to your dashboard after successful response.

  //   Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(
  //     builder: (_) => const AdminMainScreen(),
  //   ),
  // );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocietySetupBloc, SocietySetupState>(
      listenWhen: (previous, current) =>
          previous.currentStep != current.currentStep ||
          previous.completedSteps.length != current.completedSteps.length,
          listener: (context, state) {
  if (!isEditMode &&
      state.completedSteps.contains(9) &&
      !_hasNavigated) {
    _hasNavigated = true;
    _goToDashboard();
  }
},
      // listener: (context, state) {
      //   if (state.currentStep == 1) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('Society information saved successfully'),
      //         behavior: SnackBarBehavior.floating,
      //       ),
      //     );

      //     // In edit mode, return to Dashboard after Society Information update.
      //     if (isEditMode && !_hasNavigated) {
      //       _hasNavigated = true;
      //       _goToDashboard();
      //     }
      //   }

      //   if (state.completedSteps.contains(9) && !_hasNavigated) {
      //     _hasNavigated = true;
      //     _goToDashboard();
      //   }
      // },
      builder: (context, state) {
        final progress = state.completedSteps.length / 10;

        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: _buildFloatingButton(state),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.apartment_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 11),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: 'Jainam',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    CommonText(
                      text: 'SOCIETY SETUP',
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: hintColor,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              if (isEditMode)
                IconButton(
                  tooltip: 'Dashboard',
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminMainScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home, color: textColor),
                )
              else
                IconButton(
                  onPressed: () => _showSteps(state),
                  icon: const Icon(Icons.menu_rounded, color: textColor),
                ),
              const SizedBox(width: 5),
            ],
            // actions: [
            //   IconButton(
            //     onPressed: () => _showSteps(state),
            //     icon: const Icon(Icons.menu_rounded, color: textColor),
            //   ),
            //   const SizedBox(width: 5),
            // ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isEditMode
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CommonText(
                              text: 'Setup Progress',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                            CommonText(
                              text: '${state.completedSteps.length}/10 steps',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ],
                        ),
                  isEditMode ? Container() : const SizedBox(height: 10),
                  isEditMode
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFE9EAF0),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.green,
                            ),
                          ),
                        ),
                  isEditMode ? Container() : const SizedBox(height: 9),
                  isEditMode
                      ? Container()
                      : CommonText(
                          text: '${(progress * 100).round()}% completed',
                          fontSize: 11,
                          color: hintColor,
                        ),
                  isEditMode ? Container() : const SizedBox(height: 25),
                  CommonText(
                    text: steps[state.currentStep],
                    fontSize: AppTextSizes.title,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 6),
                  CommonText(
                    text: _stepDescription(state.currentStep),
                    fontSize: 12,
                    color: hintColor,
                  ),
                  const SizedBox(height: 20),
                  _buildCurrentStep(state),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: isEditMode
                  ? SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CommonButton(
                        text: 'Update',
                        height: 50,
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: () {
                          _updateDetails(state);
                        },
                      ),
                    )
                  : _buildNormalBottomButtons(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormalBottomButtons(SocietySetupState state) {
    return Row(
      children: [
        if (state.currentStep >= 2 && state.currentStep <= 9) ...[
          OutlinedButton.icon(
            onPressed: () {
              context.read<SocietySetupBloc>().add(
                SocietySetupStepChanged(state.currentStep - 1),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              side: const BorderSide(color: Color(0xFFDCE4EF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            icon: const Icon(Icons.chevron_left_rounded, size: 19),
            label: const Text('Previous'),
          ),
          const SizedBox(width: 8),
        ],

        if (state.currentStep == 6 && state.nonMembers.isEmpty)
          Expanded(
            child: 
            CommonButton(
              text: 'Skip this step',
              height: 50,
              icon: Icons.arrow_forward_rounded,
              onPressed: () => _skipNonMemberStep,
            ),
            
            
            
            // ElevatedButton(
            //   onPressed: _skipNonMemberStep,
            //   child: const Text('Skip this step'),
            // ),
          )
        else if (state.currentStep == 9)
          Expanded(
            child: CommonButton(
              text: 'Complete',
              height: 50,
              icon: Icons.check_circle_outline_rounded,
              onPressed: _completeSetup,
            ),
          )
        else
          Expanded(
            child: CommonButton(
              text: state.currentStep == 2 && state.wings.isEmpty
                  ? 'Skip'
                  : 'Save & Next',
              height: 50,
              icon: Icons.arrow_forward_rounded,
              onPressed: () => _handleNext(state),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddFinancialYearDialog() async {
    final bloc = context.read<SocietySetupBloc>();

    final result = await showAddFinancialYearBottomSheet(context: context);

    if (!mounted || result == null) return;

    bloc.add(FinancialYearAdded(result));
  }

  String _stepDescription(int step) {
    switch (step) {
      case 2:
        return 'Add wings/blocks of your society.';

      case 3:
        return 'Create flats under your wings using the floor range builder.';

      case 4:
        return 'Add society members and assign them to their flats.';

      case 5:
        return 'Configure your society financial year.';

      case 6:
        return 'Add non-members of your society.';
      case 7:
        return 'Configure the maintenance charge heads for your society.';
      case 8:
        return 'Configure expense categories for tracking society expenditures.';

      case 9:
        return 'Configure payment rules, invoice settings, tax, and reminder policies.';
      default:
        return 'Verify and complete your society details before continuing setup.';
    }
  }
}
