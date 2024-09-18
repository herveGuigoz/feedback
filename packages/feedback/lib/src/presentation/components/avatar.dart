import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    required this.name,
    super.key,
  });

  static DateFormat dateFormat = DateFormat('E, hh:mm a');

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints.tight(
            theme.avatarTheme.size ?? const Size.square(40),
          ),
          decoration: ShapeDecoration(shape: const CircleBorder(), color: theme.colorScheme.muted),
          child: Center(
            child: Text(
              name.characters.first.toUpperCase(),
              style: TextStyle(color: theme.colorScheme.mutedForeground, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
