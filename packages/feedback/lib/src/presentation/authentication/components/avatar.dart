import 'package:feedback/src/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    required this.name,
    super.key,
  });

  // static DateFormat dateFormat = DateFormat('E, hh:mm a');

  final String name;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  final popoverController = ShadPopoverController();

  @override
  void dispose() {
    popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadPopover(
      controller: popoverController,
      popover: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ShadGestureDetector(
              onTap: () {
                context.read<EventBus>().add(const LogoutRequestedEvent());
              },
              child: const Text('Logout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ShadGestureDetector(
          onTap: popoverController.toggle,
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
                    widget.name.characters.first.toUpperCase(),
                    style: TextStyle(color: theme.colorScheme.mutedForeground, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
