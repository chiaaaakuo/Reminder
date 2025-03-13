import 'package:flutter/material.dart';

class AppGradientTheme extends ThemeExtension<AppGradientTheme> {
  final Gradient? backgroundGradient;

  const AppGradientTheme({required this.backgroundGradient});

  @override
  ThemeExtension<AppGradientTheme> copyWith({Gradient? backgroundGradient}) {
    return AppGradientTheme(backgroundGradient: backgroundGradient ?? this.backgroundGradient);
  }

  @override
  ThemeExtension<AppGradientTheme> lerp(covariant ThemeExtension<AppGradientTheme>? other, double t) {
    if (other is! AppGradientTheme) {
      return this;
    }

    return AppGradientTheme(
      backgroundGradient: backgroundGradient,
    );
  }
}
