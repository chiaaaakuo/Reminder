import 'package:flutter/material.dart';
import 'package:reminder/extensions/widget_extensions.dart';
import 'package:reminder/styles/theme_extensions/list_tile_left_strip_theme.dart';
import 'package:reminder/styles/themes.dart';

class LeftStripeBox extends StatelessWidget {
  const LeftStripeBox({
    super.key,
    required this.child,
    this.borderRadius,
    this.stripeWidth,
    this.stripeColor,
    this.background,
  });

  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final double? stripeWidth;
  final Color? stripeColor;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final LeftStripeBoxTheme leftStripeTheme = context.theme.leftStripeBoxTheme;

    return ClipRRect(
      borderRadius: borderRadius ?? leftStripeTheme.borderRadius,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: stripeWidth ?? leftStripeTheme.stripWidth,
                  color: stripeColor ?? leftStripeTheme.stripColor,
                ),
                Expanded(
                  child: Container(
                    color: background ?? leftStripeTheme.background,
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
