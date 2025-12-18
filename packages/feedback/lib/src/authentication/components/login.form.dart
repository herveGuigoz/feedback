import 'dart:async';

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

  late EventBus _eventBus;

  StreamSubscription<Event>? _subscription;

  final _username = TextEditingController();

  final _password = TextEditingController();

  void _subscribe() {
    _subscription = _eventBus.on<Event>().listen((event) {
      switch (event) {
        case AuthenticationSucceededEvent():
          _onAuthenticationSucceededEvent(event);
        case AuthenticationFailedEvent():
          _onAuthenticationFailedEvent(event);
        default:
      }
    });
  }

  Future<void> _onAuthenticationSucceededEvent(AuthenticationSucceededEvent event) async {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _onAuthenticationFailedEvent(AuthenticationFailedEvent event) async {
    if (mounted) {
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          title: Text('Failed to log in. Please check your credentials and try again.'),
        ),
      );
    }
  }

  void submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      context.read<EventBus>().add(AuthenticationRequestedEvent(username: _username.text, password: _password.text));
    }
  }

  @override
  void initState() {
    super.initState();
    _eventBus = context.read<EventBus>();
    _subscribe();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
