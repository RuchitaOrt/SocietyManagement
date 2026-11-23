import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:society_management/core/constants/AppTextSizes.dart';
import 'package:society_management/core/constants/CommonImage.dart';
import 'package:society_management/core/constants/CommonString.dart';
import 'package:society_management/core/constants/app_colors.dart';

import 'package:society_management/core/widgets/CommonButton.dart';
import 'package:society_management/core/widgets/CommonText.dart';
import 'package:society_management/core/widgets/CommonTextField.dart';

import 'package:society_management/feature/auth/presentation/bloc/login_bloc.dart';
import 'package:society_management/feature/auth/presentation/bloc/login_event.dart';
import 'package:society_management/feature/auth/presentation/bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onForgotPassword,
    this.onCreateAccount,
    this.onLoginSuccess,
  });

  final VoidCallback? onForgotPassword;
  final VoidCallback? onCreateAccount;
  final ValueChanged<String?>? onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();


final _emailController =
    TextEditingController(text: 'ruchi@gmail.com');

final _passwordController =
    TextEditingController(text: '123456');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login submit
  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    context.read<LoginBloc>().add(
          LoginSubmitted(
            emailOrPhone: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.status != current.status,
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              widget.onLoginSuccess?.call(state.token);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.userName == null
                        ? CommonString.loginSuccess
                        : '${CommonString.welcome}, ${state.userName}',
                  ),
                  backgroundColor: Colors.green.shade700,
                ),
              );
            } else if (state.status == LoginStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? CommonString.loginFailed,
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      _buildHero(size.height),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          24,
                          24,
                          24,
                          24,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email label
                              const CommonText(
                                text: CommonString.emailOrPhone,
                                fontSize: AppTextSizes.bodySmall,
                                fontWeight: FontWeight.w500,
                                requiredMark: true,
                              ),

                              const SizedBox(height: 9),

                              // Email field
                              _buildEmailField(),

                              const SizedBox(height: 22),

                              // Password label
                              const CommonText(
                                text: CommonString.password,
                                fontSize: AppTextSizes.bodySmall,
                                fontWeight: FontWeight.w500,
                                requiredMark: true,
                              ),

                              const SizedBox(height: 9),

                              // Password field
                              _buildPasswordField(),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: widget.onForgotPassword,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 10,
                                    ),
                                  ),
                                  child: const CommonText(
                                    text: CommonString.forgotPassword,
                                    fontSize: AppTextSizes.bodySmall,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Sign In button
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return CommonButton(
                                    text: CommonString.signIn,
                                    icon: Icons.login_rounded,
                                    isLoading: state.isLoading,
                                    onPressed: state.isLoading
                                        ? null
                                        : _submit,
                                  );
                                },
                              ),

                              const SizedBox(height: 22),

                              // Create account
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                  children: [
                                    const CommonText(
                                      text: CommonString.newToSocietyPortal,
                                      fontSize: AppTextSizes.bodySmall,
                                      color: AppColors.body,
                                    ),

                                    TextButton(
                                      onPressed: widget.onCreateAccount,
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const CommonText(
                                        text: CommonString.createAccount,
                                        fontSize: AppTextSizes.bodySmall,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Header section
  Widget _buildHero(double screenHeight) {
    return SizedBox(
      height: (screenHeight * 0.36).clamp(250.0, 330.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            CommonImage.loginHero,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 24, 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Society icon
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .25),
                    ),
                  ),
                  padding: const EdgeInsets.all(13),
                  child: SvgPicture.asset(
                    CommonImage.societyBuilding,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Title
                const CommonText(
                  text: CommonString.loginTitle,
                  fontSize: AppTextSizes.heading,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.0,
                  letterSpacing: -.7,
                ),

                const SizedBox(height: 8),

                // Description
                const CommonText(
                  text: CommonString.loginDescription,
                  fontSize: AppTextSizes.bodySmall,
                  color: Colors.white,
                  height: 1.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Email / Phone field
  Widget _buildEmailField() {
    return CommonTextField(
      controller: _emailController,
      hintText: CommonString.emailHint,
      prefixIcon: CommonImage.email,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [
        AutofillHints.username,
        AutofillHints.email,
      ],
      validator: (value) {
        final text = value?.trim() ?? '';

        if (text.isEmpty) {
          return CommonString.enterEmailOrPhone;
        }

        if (text.contains('@') &&
            !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text)) {
          return CommonString.invalidEmail;
        }

        if (!text.contains('@') &&
            !RegExp(r'^[0-9+()\- ]{7,18}$').hasMatch(text)) {
          return CommonString.invalidEmailOrPhone;
        }

        return null;
      },
    );
  }

  // Password field
  Widget _buildPasswordField() {
    return CommonTextField(
      controller: _passwordController,
      hintText: CommonString.passwordHint,
      prefixIcon: CommonImage.lock,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [
        AutofillHints.password,
      ],
      onFieldSubmitted: (_) => _submit(),

      // Password visibility
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        icon: SvgPicture.asset(
          _obscurePassword
              ? CommonImage.eyeOff
              : CommonImage.eye,
          width: 21,
          height: 21,
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
    );
  }
}