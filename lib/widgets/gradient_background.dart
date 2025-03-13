import 'package:flutter/material.dart';
import 'package:reminder/extensions/widget_extensions.dart';
import 'package:reminder/styles/themes.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  final Gradient? gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient ??
                  context.theme.appGradientTheme.backgroundGradient ??
                  LinearGradient(
                    colors: [context.theme.colorScheme.primary, context.theme.colorScheme.onPrimary],
                  ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
