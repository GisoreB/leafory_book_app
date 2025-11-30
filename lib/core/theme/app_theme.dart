import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafory/core/styles/app_colors.dart';
import 'package:leafory/core/theme/custom_app_bar_theme.dart';
import 'package:leafory/core/theme/custom_color_theme.dart';

final class AppTheme {
  const AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    appBarTheme: CustomAppBarTheme.appBarTheme,
    textTheme: GoogleFonts.latoTextTheme(),
    extensions: <ThemeExtension<Object?>>[const CustomColorTheme()],
  );
}
