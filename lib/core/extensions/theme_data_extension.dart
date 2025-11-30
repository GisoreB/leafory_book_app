import 'package:flutter/material.dart';
import 'package:leafory/core/theme/custom_color_theme.dart';

extension ThemeDataExtension on ThemeData {
  CustomColorTheme get customColorTheme => extension<CustomColorTheme>() ?? const CustomColorTheme();
}

extension ThemeContext on BuildContext {
  ThemeData get themeData => Theme.of(this);

  CustomColorTheme get customColorTheme => themeData.customColorTheme;

  TextTheme get textTheme => themeData.textTheme;
}
