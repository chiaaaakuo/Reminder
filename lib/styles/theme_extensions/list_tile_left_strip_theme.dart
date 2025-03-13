import 'package:flutter/material.dart';

class LeftStripeBoxTheme extends ThemeExtension<LeftStripeBoxTheme> {
  final Color? background;
  final Color? stripColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double stripWidth;
  final BorderRadius borderRadius;

  const LeftStripeBoxTheme({
    this.background,
    this.stripColor,
    this.padding,
    this.textStyle,
    this.stripWidth = 6,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  ThemeExtension<LeftStripeBoxTheme> copyWith({
    Color? background,
    Color? stripColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    double? stripWidth,
    BorderRadius? borderRadius,
  }) {
    return LeftStripeBoxTheme(
      background: background ?? this.background,
      stripColor: stripColor ?? this.stripColor,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      stripWidth: stripWidth ?? this.stripWidth,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ThemeExtension<LeftStripeBoxTheme> lerp(covariant ThemeExtension<LeftStripeBoxTheme>? other, double t) {
    if (other is! LeftStripeBoxTheme) {
      return this;
    }

    return LeftStripeBoxTheme(
      background: Color.lerp(background, other.background, t),
      stripColor: Color.lerp(stripColor, other.stripColor, t),
      padding: padding,
      textStyle: textStyle,
      stripWidth: stripWidth,
    );
  }
}
