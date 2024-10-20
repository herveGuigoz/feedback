import 'package:flutter/material.dart';

class Unfocus extends StatelessWidget {
  const Unfocus({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
