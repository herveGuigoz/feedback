import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    required this.name,
    required this.date,
    this.dense = true,
    this.padding,
    super.key,
  });

  static DateFormat dateFormat = DateFormat('E, hh:mm a');

  final String name;

  final DateTime date;

  final bool dense;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      contentPadding: padding,
      leading: const CircleAvatar(radius: 12),
      title: Text(
        name,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      trailing: Text(
        dateFormat.format(date),
        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w300),
      ),
    );
  }
}
