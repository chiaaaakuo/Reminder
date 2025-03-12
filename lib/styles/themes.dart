import 'package:flutter/material.dart';
import 'package:reminder/styles/app_colors.dart' show AppColors;
import 'package:reminder/styles/theme_extensions/app_gradient_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData.light().copyWith(
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.tertiaryColor),
    ),
    dividerTheme: const DividerThemeData().copyWith(color: AppColors.primaryColor, thickness: 2),
    progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
      color: AppColors.tertiaryColor,
      linearTrackColor: AppColors.primaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primaryColor,
      surface: AppColors.transparent,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.fromMap({
        WidgetState.selected: AppColors.white,
        WidgetState.any: AppColors.tertiaryColor,
      }),
      trackColor: WidgetStateProperty.fromMap({
        WidgetState.selected: AppColors.tertiaryColor,
        WidgetState.any: AppColors.white,
      }),
      trackOutlineColor: WidgetStatePropertyAll(AppColors.transparent),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: AppColors.primaryColor, fontSize: 40),
      titleMedium: TextStyle(color: AppColors.primaryColor, fontSize: 18),
      titleSmall: TextStyle(color: AppColors.primaryColor, fontSize: 16),
      bodyLarge: TextStyle(color: AppColors.tertiaryColor, fontSize: 20),
      bodyMedium: TextStyle(color: AppColors.tertiaryColor, fontSize: 18),
      bodySmall: TextStyle(color: AppColors.tertiaryColor, fontSize: 16),
    ),
    listTileTheme: ListTileThemeData(
      textColor: AppColors.primaryColor,
      iconColor: AppColors.tertiaryColor,
      tileColor: AppColors.white,
      selectedTileColor: AppColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
    ),
    extensions: [
      AppGradientTheme(backgroundGradient: _lightBackgroundGradient),
    ],
  );

  static final Gradient _lightBackgroundGradient = LinearGradient(
    colors: [AppColors.blueLight, AppColors.purpleLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
