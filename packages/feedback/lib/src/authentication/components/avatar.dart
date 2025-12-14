import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    required this.name,
    super.key,
  });

  final String name;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  Future<void> _onLogoutTapped() async {
    final answer = await LogoutDialog.show(context);
    if ((answer ?? false) && mounted) {
      context.read<EventBus>().add(const LogoutRequestedEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final username = context.select((AuthenticationBloc auth) => auth.state?.username ?? '');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ShadGestureDetector(
        onTap: _onLogoutTapped,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints.tight(
                theme.avatarTheme.size ?? const Size.square(40),
              ),
              decoration: ShapeDecoration(shape: const CircleBorder(), color: theme.colorScheme.muted),
              child: Center(
                child: Text(
                  username.characters.first.toUpperCase(),
                  style: TextStyle(color: theme.colorScheme.mutedForeground, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showShadDialog<bool>(context: context, builder: (_) => const LogoutDialog());
  }

  @override
  Widget build(BuildContext context) {
    return ShadDialog.alert(
      title: const Text('Are you absolutely sure?'),
      description: const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text('This action will log you out of your account.'),
      ),
      actions: [
        ShadButton.outline(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ShadButton(
          child: const Text('Continue'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
