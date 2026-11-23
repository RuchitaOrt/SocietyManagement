import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFE92E86);
  static const Color primaryDark = Color(0xFFD91F78);
  static const Color orange = Color(0xFFFF812F);
  static const Color navy = Color(0xFF111B3A);
  static const Color body = Color(0xFF647797);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDCE4F0);
  static const Color fieldFill = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFF9FC);
  static const Color error = Color(0xFFD92D45);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFEF3B9A), Color(0xFFE92768), Color(0xFFFF812F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFEF3B9A), Color(0xFFD91F78)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
