import 'package:flutter/material.dart';
import 'package:reminder/extensions/widget_extensions.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    Key? key,
    this.gradient,
    required this.child,
  }) : super(key: key);

  final Gradient? gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? LinearGradient(colors: [context.theme.colorScheme.primary, context.theme.colorScheme.onPrimary]),
      ),
      child: child,
    );
  }
}
