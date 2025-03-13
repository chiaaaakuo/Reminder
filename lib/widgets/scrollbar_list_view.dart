import 'package:flutter/material.dart';
import 'package:reminder/extensions/widget_extensions.dart';

class ScrollbarListView extends StatelessWidget {
  const ScrollbarListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.controller,
    this.scrollbarThickness = 10,
    this.scrollbarIndicatorVisibility,
    this.scrollbarIndicatorColor,
    this.separatorBuilder,
    this.scrollbarRadius,

  });

  final ScrollController? controller;
  final double scrollbarThickness;
  final double? scrollbarRadius;
  final bool? scrollbarIndicatorVisibility;
  final Color? scrollbarIndicatorColor;
  final EdgeInsetsGeometry? padding;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thickness: scrollbarThickness,
      radius:  Radius.circular(scrollbarRadius ?? scrollbarThickness),
      thumbVisibility: scrollbarIndicatorVisibility,
      thumbColor: scrollbarIndicatorColor ?? context.theme.colorScheme.tertiary,
      child: _listView,
    );
  }

  Widget get _listView {
    if (separatorBuilder!=null) {
      return ListView.separated(
        controller: controller,
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder!,
      );
    }
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );

  }
}
