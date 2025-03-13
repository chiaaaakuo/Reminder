import 'package:flutter/material.dart';
import 'package:reminder/styles/app_colors.dart' show AppColors;
import 'package:reminder/styles/theme_extensions/app_gradient_theme.dart';
import 'package:reminder/styles/theme_extensions/list_tile_left_strip_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData.light().copyWith(
    dividerTheme: const DividerThemeData().copyWith(color: AppColors.primaryColor, thickness: 2, space: 2),
    progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
      color: AppColors.secondaryColor,
      linearTrackColor: AppColors.white,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: AppColors.primaryColor,
      surface: AppColors.transparent,
      onPrimary: AppColors.white,
      tertiary: AppColors.tertiaryColor,
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
      titleLarge: TextStyle(color: AppColors.primaryColor, fontSize: 36),
      titleMedium: TextStyle(color: AppColors.primaryColor, fontSize: 18),
      titleSmall: TextStyle(color: AppColors.primaryColor, fontSize: 16),
      bodyLarge: TextStyle(color: AppColors.secondaryColor, fontSize: 20),
      bodyMedium: TextStyle(color: AppColors.secondaryColor, fontSize: 18),
      bodySmall: TextStyle(color: AppColors.secondaryColor, fontSize: 16),
      labelMedium: TextStyle(color: AppColors.grey, fontSize: 18),
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
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.grey, width: 1),
    ),
    extensions: [
      _lightGradientTheme,
      _leftStripeBoxTheme,
    ],
  );

  static final _lightGradientTheme = AppGradientTheme(
    backgroundGradient: LinearGradient(
      colors: [AppColors.blueLight, AppColors.purpleLight],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static final _leftStripeBoxTheme = LeftStripeBoxTheme(
    background: AppColors.white,
    stripColor: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(4),
  );
}

extension AppThemeExtension on ThemeData {
  ColorScheme get colorScheme => this.colorScheme;

  TextTheme get textTheme => this.textTheme;

  AppGradientTheme get appGradientTheme => extension<AppGradientTheme>() ?? AppTheme._lightGradientTheme;

  LeftStripeBoxTheme get listTileLeftStripTheme => extension<LeftStripeBoxTheme>() ?? AppTheme._leftStripeBoxTheme;
}
