import 'package:feedback/src/app/feedback.dart';
import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  static Future<void> show(BuildContext context) async {
    return FeedbackApp.showDialog(context: context, builder: (_) => const LoginForm());
  }

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<ShadFormState>();

  final _username = TextEditingController();

  final _password = TextEditingController();

  void submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      context.read<EventBus>().add(AuthenticationRequestedEvent(username: _username.text, password: _password.text));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add BlocListener to show error messages on login failure and pop dialog on success
    return ShadDialog(
      title: const Text('Login'),
      description: const Text('Please enter your credentials to login.'),
      actions: [ShadButton(onPressed: submitForm, child: const Text('Submit'))],
      child: ShadForm(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 375),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Username')),
                    const Gap(16),
                    Expanded(
                      flex: 3,
                      child: ShadInputFormField(
                        id: 'username',
                        keyboardType: TextInputType.name,
                        controller: _username,
                        validator: (value) => value.isEmpty ? 'Username is required' : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Password')),
                    const Gap(16),
                    Expanded(
                      flex: 3,
                      child: ShadInputFormField(
                        id: 'password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: _password,
                        validator: (value) => value.length >= 8 ? null : 'Password must be at least 8 characters',
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
