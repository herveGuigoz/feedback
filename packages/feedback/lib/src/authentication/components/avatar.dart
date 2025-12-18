import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/authentication/components/login_button.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final username = context.select((AuthenticationBloc auth) => auth.state?.username);

    return switch (username) {
      final String name => Container(
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
      _ => const LoginButton(),
    };
  }
}
