import 'package:flutter/material.dart';

class ListTileLeftStripeTheme extends ThemeExtension<ListTileLeftStripeTheme> {
  final Color? background;
  final Color? stripColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double stripWidth;
  final BorderRadius borderRadius;

  const ListTileLeftStripeTheme({
    this.background,
    this.stripColor,
    this.padding,
    this.textStyle,
    this.stripWidth = 6,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  ThemeExtension<ListTileLeftStripeTheme> copyWith({
    Color? background,
    Color? stripColor,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    double? stripWidth,
    BorderRadius? borderRadius,
  }) {
    return ListTileLeftStripeTheme(
      background: background ?? this.background,
      stripColor: stripColor ?? this.stripColor,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      stripWidth: stripWidth ?? this.stripWidth,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ThemeExtension<ListTileLeftStripeTheme> lerp(covariant ThemeExtension<ListTileLeftStripeTheme>? other, double t) {
    if (other is! ListTileLeftStripeTheme) {
      return this;
    }

    return ListTileLeftStripeTheme(
      background: Color.lerp(background, other.background, t),
      stripColor: Color.lerp(stripColor, other.stripColor, t),
      padding: padding,
      textStyle: textStyle,
      stripWidth: stripWidth,
    );
  }
}
