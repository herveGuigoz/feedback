import 'package:flutter/material.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.username,
    required this.date,
    super.key,
  });

  final String username;

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final avatar = CircleAvatar(
      radius: 12,
      backgroundColor: Colors.grey.shade300,
      child: Text(username[0].toUpperCase(), style: theme.textTheme.small.copyWith(fontSize: 8)),
    );

    final title = Text(username, style: theme.textTheme.small.copyWith(fontSize: 10));

    final subtitle = Text(
      DateFormat('E, hh:mm a').format(date),
      style: theme.textTheme.small.copyWith(fontSize: 8, color: Colors.grey.shade600),
    );

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      leading: avatar,
      title: title,
      trailing: subtitle,
    );
  }
}
