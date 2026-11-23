import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:society_management/core/constants/AppTextSizes.dart';
import 'package:society_management/core/constants/CommonImage.dart';
import 'package:society_management/core/constants/CommonString.dart';
import 'package:society_management/core/constants/app_colors.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

import 'package:society_management/feature/auth/presentation/bloc/registration_bloc.dart';
import 'package:society_management/feature/auth/presentation/bloc/registration_event.dart';
import 'package:society_management/feature/auth/presentation/bloc/registration_state.dart';
import 'package:society_management/feature/auth/presentation/pages/LoginScreen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationBloc(),
      child: const RegistrationView(),
    );
  }
}

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _societyFormKey = GlobalKey<FormState>();
  final _adminFormKey = GlobalKey<FormState>();

  final societyNameController = TextEditingController();
  final registrationCodeController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();

  final adminNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptedTerms = false;
bool showPlanOptions = false;

String selectedPlan = 'Trial';

final List<Map<String, dynamic>> plans = [
  {
    'name': 'Trial',
    'price': '₹0',
    'duration': '20 days',
  },
  {
    'name': 'Monthly',
    'price': '₹499',
    'duration': '30 days',
  },
  {
    'name': 'Quarterly',
    'price': '₹2,299',
    'duration': '90 days',
  },
  {
    'name': 'Yearly',
    'price': '₹9,999',
    'duration': '365 days',
  },
];
Widget _buildPlanSelection() {
  return Align(
    alignment: Alignment.topCenter,
    child: AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      child: showPlanOptions
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plans.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 90,
                  ),
                  itemBuilder: (context, index) {
                    final plan = plans[index];

                    final isSelected =
                        selectedPlan == plan['name'];

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedPlan = plan['name'];
                          showPlanOptions = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFF3F8)
                              : const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFEC3181)
                                : const Color(0xFFE2E7EF),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CommonText(
                                    text: plan['name'],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF172238),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Color(0xFFEC3181),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            CommonText(
                              text: plan['price'],
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEC3181),
                            ),
                            CommonText(
                              text: plan['duration'],
                              fontSize: 10,
                              color: const Color(0xFF71819D),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          : const SizedBox(width: double.infinity),
    ),
  );
}
  @override
  void dispose() {
    societyNameController.dispose();
    registrationCodeController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    stateController.dispose();

    adminNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }


void _nextStep() {
  final currentStep = context.read<RegistrationBloc>().state.currentStep;

  if (currentStep == 0) {
    if (!_societyFormKey.currentState!.validate()) return;

    context.read<RegistrationBloc>().add(RegistrationNextStep());
  } else if (currentStep == 1) {
    if (!_adminFormKey.currentState!.validate()) return;

    _showOtpBottomSheet();
  }
}


  void _completeRegistration() {
    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(CommonString.acceptTerms),
        ),
      );
      return;
    }

    context.read<RegistrationBloc>().add(RegistrationComplete());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(CommonString.registrationSuccess),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Container(
                constraints: const BoxConstraints(minHeight: 545),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 35,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 750;

                    if (isMobile) {
                      return Column(
                        children: [
                          _buildLeftPanel(isMobile: true),
                          _buildRightPanel(),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 323,
                          child: _buildLeftPanel(),
                        ),
                        Expanded(child: _buildRightPanel()),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // LEFT GRADIENT PANEL

  Widget _buildLeftPanel({bool isMobile = false}) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE72D79),
            Color(0xFFE91E45),
            Color(0xFFFF6414),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),

          const SizedBox(height: 32),

          const CommonText(
            text: CommonString.appName,
            fontSize: 29,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),

          const SizedBox(height: 10),

          const CommonText(
            text: CommonString.loginDescription,
            fontSize: 12,
            color: Colors.white,
            height: 1.6,
          ),

          const SizedBox(height: 30),

          _featureItem('Member management'),
          _featureItem('Role-based access'),
          _featureItem('Real-time tracking'),
          _featureItem('Plan & billing control'),
         SizedBox(height: 10,),
           Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    const CommonText(
                                      text: CommonString.alreadyRegistered,
                                      fontSize: AppTextSizes.bodySmall,
                                      color: AppColors.white,
                                    ),

                                    TextButton(
                                      onPressed:()
                                      {
                                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const CommonText(
                                        text: "${CommonString.signIn} →",
                                        fontSize: AppTextSizes.bodySmall,
                                        fontWeight: FontWeight.w700,
                                      color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
          if (!isMobile) const Spacer(),

          if (!isMobile) ...[
            const Divider(color: Colors.white30, height: 45),

            Row(
              children: [
                const CommonText(
                  text: CommonString.alreadyRegistered,
                  color: Colors.white,
                  fontSize: 12,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CommonText(
                    text: CommonString.signIn,
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _featureItem(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            color: Colors.white,
            size: 7,
          ),
          const SizedBox(width: 10),
          CommonText(
            text: text,
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  // RIGHT CONTENT PANEL

  Widget _buildRightPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 30, 32, 28),
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.completed) {
            // UI-only registration.
            // Add API integration here later.
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.apartment_rounded,
                    color: Color(0xFFEF398C),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const CommonText(
                    text: CommonString.registerSociety,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF151D32),
                  ),
                ],
              ),

              const SizedBox(height: 3),

              const CommonText(
                text: CommonString.registerDescription,
                fontSize: 11,
                color: Color(0xFF71819D),
              ),

              const SizedBox(height: 25),

              _buildStepIndicator(state.currentStep),

              const SizedBox(height: 28),

              if (state.currentStep == 0) _buildSocietyStep(),

              if (state.currentStep == 1) _buildAdminStep(),

              if (state.currentStep == 2) _buildPlanStep(),

              const SizedBox(height: 28),

              const Divider(color: Color(0xFFEDF0F5)),

              const SizedBox(height: 12),

              _buildBottomNavigation(state.currentStep),
            ],
          );
        },
      ),
    );
  }

  // STEP INDICATOR

  Widget _buildStepIndicator(int currentStep) {
    final titles = [
      CommonString.societyIdentity,
      CommonString.adminAccount,
      CommonString.planLegal,
    ];

    final subtitles = [
      CommonString.identitySubtitle,
      CommonString.adminSubtitle,
      CommonString.planSubtitle,
    ];

    return Row(
      children: List.generate(3, (index) {
        final isActive = currentStep == index;
        final isCompleted = currentStep > index;

        return Expanded(
          child: Row(
            children: [
              Container(
                height: 29,
                width: 29,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFEC3181)
                      : isCompleted
                          ? const Color(0xFFEAF8F1)
                          : const Color(0xFFF0F3F8),
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  size: isCompleted ? 15 : 7,
                  color: isActive
                      ? Colors.white
                      : isCompleted
                          ? Colors.green
                          : const Color(0xFF9BAAC0),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      text: titles[index],
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isActive || isCompleted
                          ? const Color(0xFF26344B)
                          : const Color(0xFF9BAAC0),
                    ),
                    CommonText(
                      text: subtitles[index],
                      fontSize: 9,
                      color: const Color(0xFF91A1B8),
                    ),
                  ],
                ),
              ),

              if (index != 2)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    color: isCompleted
                        ? Colors.green
                        : const Color(0xFFDCE3ED),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // STEP 1: SOCIETY DETAILS

  Widget _buildSocietyStep() {
    return Form(
      key: _societyFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _field(
                  label: CommonString.societyName,
                  hint: CommonString.societyNameHint,
                  controller: societyNameController,
                  icon: CommonImage.societyBuilding,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return CommonString.enterSocietyName;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _field(
                  label: CommonString.registrationCode,
                  optional: true,
                  hint: CommonString.registrationCodeHint,
                  controller: registrationCodeController,
                  icon: CommonImage.societyBuilding,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _field(
            label: CommonString.address,
            hint: CommonString.addressHint,
            controller: addressController,
            icon: CommonImage.location,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return CommonString.enterAddress;
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _field(
                  label: CommonString.pincode,
                  hint: CommonString.pincodeHint,
                  controller: pincodeController,
                  icon: CommonImage.hashtag,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return CommonString.enterPincode;
                    }
                    if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
                      return CommonString.invalidPincode;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _field(
                  label: CommonString.city,
                  hint: CommonString.cityHint,
                  controller: cityController,
                  icon: CommonImage.location,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return CommonString.enterCity;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _field(
                  label: CommonString.state,
                  hint: CommonString.stateHint,
                  controller: stateController,
                  icon: CommonImage.location,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return CommonString.enterState;
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // STEP 2: ADMIN ACCOUNT

  Widget _buildAdminStep() {
    return Form(
      key: _adminFormKey,
      child: Column(
        children: [
          _field(
            label: CommonString.adminName,
            hint: CommonString.adminNameHint,
            controller: adminNameController,
            icon: CommonImage.societyBuilding,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return CommonString.enterAdminName;
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          _field(
            label: CommonString.emailAddress,
            hint: CommonString.emailAddressHint,
            controller: emailController,
            icon: CommonImage.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return CommonString.enterEmail;
              }
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                  .hasMatch(value.trim())) {
                return CommonString.invalidEmail;
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          _field(
            label: CommonString.mobileNumber,
            hint: CommonString.mobileNumberHint,
            controller: mobileController,
            icon: CommonImage.email,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return CommonString.enterMobile;
              }
              if (!RegExp(r'^[0-9+()\- ]{7,18}$')
                  .hasMatch(value.trim())) {
                return CommonString.enterMobile;
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          _field(
            label: CommonString.password,
            hint: CommonString.passwordHint,
            controller: passwordController,
            icon: CommonImage.lock,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF91A2BF),
                size: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return CommonString.enterPassword;
              }
              if (value.length < 6) {
                return CommonString.passwordMinLength;
              }
              return null;
            },
          ),

          // const SizedBox(height: 18),

          // _field(
          //   label: CommonString.confirmPassword,
          //   hint: CommonString.confirmPasswordHint,
          //   controller: confirmPasswordController,
          //   icon: CommonImage.lock,
          //   obscureText: obscureConfirmPassword,
          //   suffixIcon: IconButton(
          //     onPressed: () {
          //       setState(() {
          //         obscureConfirmPassword = !obscureConfirmPassword;
          //       });
          //     },
          //     icon: Icon(
          //       obscureConfirmPassword
          //           ? Icons.visibility_off
          //           : Icons.visibility,
          //       color: const Color(0xFF91A2BF),
          //       size: 20,
          //     ),
          //   ),
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return CommonString.enterPassword;
          //     }
          //     if (value != passwordController.text) {
          //       return CommonString.passwordMismatch;
          //     }
          //     return null;
          //   },
          // ),
        ],
      ),
    );
  }

Future<void> _showOtpBottomSheet() async {
  final otpController = TextEditingController();
  final otpFocusNode = FocusNode();

  final otpVerified = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE2EA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Icon(
                  Icons.mark_email_read_rounded,
                  size: 45,
                  color: Color(0xFFEC3181),
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: CommonText(
                  text: 'Verify Admin Account',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF172238),
                ),
              ),

              const SizedBox(height: 8),

              const CommonText(
                text:
                    'Enter the 6-digit verification code sent to your registered email or mobile number.',
                fontSize: 12,
                color: Color(0xFF71819D),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Six individual OTP boxes
              GestureDetector(
                onTap: () {
                  otpFocusNode.requestFocus();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return ValueListenableBuilder<TextEditingValue>(
                          valueListenable: otpController,
                          builder: (context, value, child) {
                            final digits = value.text;
                            final digit = index < digits.length
                                ? digits[index]
                                : '';

                            final isActive = digits.length == index;

                            return Container(
                              height: 54,
                              width: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F9FC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFFEC3181)
                                      : const Color(0xFFDDE5F0),
                                  width: isActive ? 1.6 : 1,
                                ),
                              ),
                              child: Text(
                                digit,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF172238),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    // Invisible input field handles keyboard input.
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0,
                        child: TextField(
                          controller: otpController,
                          focusNode: otpFocusNode,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              CommonButton(
                text: 'Verify & Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  final otp = otpController.text.trim();

                  if (!RegExp(r'^[0-9]{6}$').hasMatch(otp)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid 6-digit OTP',
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(sheetContext, true);
                },
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () {
                    otpController.clear();
                    otpFocusNode.requestFocus();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'OTP resend will be available soon.',
                        ),
                      ),
                    );
                  },
                  child: const CommonText(
                    text: 'Resend OTP',
                    fontSize: 13,
                    color: Color(0xFFEC3181),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  otpController.dispose();
  otpFocusNode.dispose();

  if (otpVerified == true && mounted) {
    context.read<RegistrationBloc>().add(
      RegistrationOtpVerified(),
    );
  }
}


  // STEP 3: PLAN AND LEGAL

  Widget _buildPlanStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    Container(
  padding: const EdgeInsets.all(15),
  decoration: BoxDecoration(
    color: const Color(0xFFF7F9FC),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color(0xFFDDE5F0),
    ),
  ),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonText(
              text: CommonString.selectedPortalPlan,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFF71819D),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                CommonText(
                  text: selectedPlan,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF172238),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CommonText(
                    text: plans.firstWhere(
                      (p) => p['name'] == selectedPlan,
                    )['price'] +
                        ' • ' +
                        plans.firstWhere(
                          (p) => p['name'] == selectedPlan,
                        )['duration'],
                    fontSize: 10,
                    color: const Color(0xFFEB3285),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      OutlinedButton(
        onPressed: () {
          setState(() {
            showPlanOptions = !showPlanOptions;
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEC3181),
          side: const BorderSide(
            color: Color(0xFFEC3181),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        child: CommonText(
          text: showPlanOptions ? 'Cancel' : 'Change Plan',
          fontSize: 11,
          color: const Color(0xFFEC3181),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
),
_buildPlanSelection(),

const SizedBox(height: 18),
        const SizedBox(height: 18),
        const Divider(color: Color(0xFFEDF0F5)),
        const SizedBox(height: 12),

        _summaryRow(
          CommonString.societyRegisteredName,
          societyNameController.text,
        ),

        const SizedBox(height: 12),

        _summaryRow(
          CommonString.assignedAdministrator,
          adminNameController.text,
          subtitle: emailController.text,
        ),

        const SizedBox(height: 18),
        const Divider(color: Color(0xFFEDF0F5)),
        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: acceptedTerms,
              activeColor: const Color(0xFFEC3181),
              onChanged: (value) {
                setState(() {
                  acceptedTerms = value ?? false;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  children: [
                    const CommonText(
                      text: CommonString.termsAgreement,
                      fontSize: 11,
                      color: Color(0xFF53637E),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Open Terms & Privacy Policy page later.
                      },
                      child: const CommonText(
                        text: CommonString.termsPrivacy,
                        fontSize: 11,
                        color: Color(0xFFEC3181),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const CommonText(
                      text: '.',
                      fontSize: 11,
                      color: Color(0xFF53637E),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CommonText(
            text: title,
            fontSize: 11,
            color: const Color(0xFF71819D),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text: value.isEmpty ? '-' : value,
                fontSize: 11,
                color: const Color(0xFF172238),
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.end,
              ),
              if (subtitle != null && subtitle.isNotEmpty)
                CommonText(
                  text: subtitle,
                  fontSize: 10,
                  color: const Color(0xFF71819D),
                  textAlign: TextAlign.end,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // COMMON FIELD

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool optional = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              text: label.toUpperCase(),
              fontSize: 10,
              color: const Color(0xFF647692),
              fontWeight: FontWeight.w600,
            ),
            if (validator != null)
              const CommonText(
                text: ' *',
                fontSize: 11,
                color: Color(0xFFEC3181),
                fontWeight: FontWeight.w700,
              ),
            if (optional) ...[
              const SizedBox(width: 5),
              const CommonText(
                text: CommonString.optional,
                fontSize: 10,
                color: Color(0xFF91A2BF),
              ),
            ],
          ],
        ),

        const SizedBox(height: 7),

        CommonTextField(
          controller: controller,
          hintText: hint,
          prefixIcon: icon,
          keyboardType: keyboardType,
          obscureText: obscureText,
          suffixIcon: suffixIcon,
          validator: validator,
        ),
      ],
    );
  }

  // BOTTOM NAVIGATION

Widget _buildBottomNavigation(int currentStep) {
  String buttonText;

  if (currentStep == 0) {
    buttonText = 'Continue';
  } else if (currentStep == 1) {
    buttonText = 'Send OTP';
  } else {
    buttonText = CommonString.completeRegistry;
  }

  return Row(
    children: [
      if (currentStep > 0)
        TextButton(
          onPressed: () {
            context
                .read<RegistrationBloc>()
                .add(RegistrationPreviousStep());
          },
          child: const CommonText(
            text: CommonString.back,
            color: Color(0xFF71819D),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

      const Spacer(),

      Row(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: currentStep == index ? 19 : 8,
            decoration: BoxDecoration(
              color: currentStep == index
                  ? const Color(0xFFEC3181)
                  : const Color(0xFFCBD5E2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      const Spacer(),

      SizedBox(
        width: currentStep == 2 ? 172 : 150,
        child: CommonButton(
          text: buttonText,
          height: 44,
          icon: currentStep == 2
              ? Icons.verified_outlined
              : currentStep == 1
                  ? Icons.send_rounded
                  : Icons.chevron_right,
          onPressed: currentStep == 2
              ? _completeRegistration
              : _nextStep,
        ),
      ),
    ],
  );
}

}