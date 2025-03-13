import 'package:flutter/material.dart';
import 'package:reminder/extensions/widget_extensions.dart';

class ProgressTracker extends StatelessWidget {
  const ProgressTracker({
    super.key,
    this.progress = 0,
    this.progressHeight = 14,
    this.padding,
    this.spacing = 10.0,
    this.label,
  });

  final double progress;
  final double progressHeight;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final Text? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        spacing: spacing,
        children: [
          label ?? Text("${(progress * 100).round()}%", style: context.theme.textTheme.titleMedium),
          Expanded(
            child: LinearProgressIndicator(
              value: progress,
              minHeight: progressHeight,
              borderRadius: BorderRadius.circular(progressHeight / 2),
            ),
          ),
        ],
      ),
    );
  }
}
