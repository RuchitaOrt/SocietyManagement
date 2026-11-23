import 'package:flutter/material.dart';
import 'package:society_management/core/constants/AppTextSizes.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

 
  static const TextStyle body = TextStyle(
    fontSize: AppTextSizes.bodyMedium,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryDark,
  );

  static const TextStyle button = TextStyle(
    fontSize: AppTextSizes.button,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}