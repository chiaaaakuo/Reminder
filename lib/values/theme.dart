import 'package:flutter/material.dart';
import 'package:reminder/styles/app_colors.dart' show AppColors;

class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColor,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.tertiaryColor),
    ),
  );
}
