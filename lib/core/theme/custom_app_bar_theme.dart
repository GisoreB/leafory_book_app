import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafory/core/styles/app_colors.dart';

final class CustomAppBarTheme {
  const CustomAppBarTheme._();

  static final AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors.lightBackground,
    iconTheme: const IconThemeData(color: AppColors.primary, size: 24),
    titleTextStyle: GoogleFonts.lato(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 22),
  );
}
