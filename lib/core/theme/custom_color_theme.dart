import 'package:flutter/material.dart';
import 'package:leafory/core/styles/app_colors.dart';

final class CustomColorTheme extends ThemeExtension<CustomColorTheme> {
  const CustomColorTheme({
    this.primary = AppColors.primary,
    this.primaryVariant = AppColors.primaryVariant,
    this.primaryLight = AppColors.primaryLight,
    this.lightBackground = AppColors.lightBackground,
    this.textPrimary = AppColors.textPrimary,
    this.textSecondary = AppColors.textSecondary,
    this.neutralInactive = AppColors.neutralInactive,
    this.success = AppColors.success,
    this.error = AppColors.error,
    this.black = AppColors.black,
    this.white = AppColors.white,
    this.transparent = AppColors.transparent,
  });

  final Color primary;
  final Color primaryVariant;
  final Color primaryLight;
  final Color lightBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color neutralInactive;
  final Color success;
  final Color error;
  final Color black;
  final Color white;
  final Color transparent;

  @override
  ThemeExtension<CustomColorTheme> copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? primaryLight,
    Color? lightBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? neutralInactive,
    Color? success,
    Color? error,
    Color? black,
    Color? white,
    Color? transparent,
  }) {
    return CustomColorTheme(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      primaryLight: primaryLight ?? this.primaryLight,
      lightBackground: lightBackground ?? this.lightBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      neutralInactive: neutralInactive ?? this.neutralInactive,
      success: success ?? this.success,
      error: error ?? this.error,
      black: black ?? this.black,
      white: white ?? this.white,
      transparent: transparent ?? this.transparent,
    );
  }

  @override
  ThemeExtension<CustomColorTheme> lerp(covariant ThemeExtension<CustomColorTheme>? other, double t) {
    return other == null ? this : const CustomColorTheme();
  }
}
