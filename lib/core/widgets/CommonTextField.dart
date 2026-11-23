import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:society_management/core/constants/AppFonts.dart';
import 'package:society_management/core/constants/AppTextSizes.dart';

import '../constants/app_colors.dart';


class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints,
    this.maxLength,
this.textAlign = TextAlign.start,
  });

  final TextEditingController controller;
  final String hintText;
  final String? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final int? maxLength;
final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      maxLength: maxLength,
textAlign: textAlign,
      onFieldSubmitted: onFieldSubmitted,
      style: AppFonts.regular.copyWith(
        fontSize: AppTextSizes.bodyMedium,
        color: AppColors.navy,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppFonts.regular.copyWith(
          color: const Color(0xFF91A2BF),
          fontSize: AppTextSizes.hint,
        ),
        helperText: ' ',
  helperStyle: const TextStyle(
    fontSize: 10,
    height: 1.2,
    color: Colors.transparent,
  ),

  errorStyle: const TextStyle(
    fontSize: 10,
    height: 1.2,
    color: Colors.red,
  ),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.all(14),
                child: SvgPicture.asset(
                  prefixIcon!,
                  width: 20,
                  height: 20,
                ),
              ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(
          color: AppColors.primary,
          width: 1.5,
        ),
        errorBorder: _border(color: AppColors.error),
        focusedErrorBorder: _border(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }

  OutlineInputBorder _border({
    Color color = AppColors.border,
    double width = 1.3,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(13),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}