import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({
    this.child,
    this.controller,
    this.constraints = const BoxConstraints(maxWidth: kDefaultMaxWidth),
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final ScrollController? controller;

  final BoxConstraints constraints;

  final EdgeInsetsGeometry padding;

  final Widget? child;

  static const double kDefaultMaxWidth = 1000;

  @override
  Widget build(BuildContext context) {
    Widget child = SelectionArea(
      child: Center(
        child: ConstrainedBox(
          constraints: constraints,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Padding(
              padding: padding,
              child: this.child,
            ),
          ),
        ),
      ),
    );

    if (controller != null) {
      child = Scrollbar(controller: controller, child: child);
    }

    return child;
  }
}
