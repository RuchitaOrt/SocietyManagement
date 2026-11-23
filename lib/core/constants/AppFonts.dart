import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextStyle get regular =>
      GoogleFonts.poppins(fontWeight: FontWeight.w400);

  static TextStyle get medium =>
      GoogleFonts.poppins(fontWeight: FontWeight.w500);

  static TextStyle get semiBold =>
      GoogleFonts.poppins(fontWeight: FontWeight.w600);

  static TextStyle get bold =>
      GoogleFonts.poppins(fontWeight: FontWeight.w700);

  static TextStyle get extraBold =>
      GoogleFonts.poppins(fontWeight: FontWeight.w800);
}