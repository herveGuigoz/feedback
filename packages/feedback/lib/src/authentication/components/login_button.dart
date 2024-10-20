import 'package:feedback/src/authentication/components/login.form.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: () => LoginForm.show(context),
      child: const Text('Login'),
    );
  }
}
