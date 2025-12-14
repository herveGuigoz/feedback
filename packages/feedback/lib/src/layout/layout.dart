import 'dart:async';
import 'dart:ui' as ui;

import 'package:feedback/src/app/bloc/app_bloc.dart';
import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/authentication/components/avatar.dart';
import 'package:feedback/src/authentication/components/login_button.dart';
import 'package:feedback/src/devices/bloc/device_bloc.dart';
import 'package:feedback/src/devices/components/devices_button.dart';
import 'package:feedback/src/feedbacks/create/views/feedback_form.dart';
import 'package:feedback/src/feedbacks/index/index.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/components/measurer.dart';
import 'package:feedback/src/shared/components/panes.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

part 'bottom.dart';
part 'left.dart';
part 'right.dart';

class FeedbackLayout extends StatefulWidget {
  const FeedbackLayout({required this.child, super.key});

  final Widget child;

  @override
  State<FeedbackLayout> createState() => _FeedbackLayoutState();
}

class _FeedbackLayoutState extends State<FeedbackLayout> {
  late EventBus _eventBus;

  StreamSubscription<Event>? _subscription;

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
      ShadToaster.of(context).show(
        ShadToast(
          title: const Text('Welcome back!'),
          description: Text('You are now logged in as ${event.user.username}.'),
        ),
      );
    }
  }

  Future<void> _onAuthenticationFailedEvent(AuthenticationFailedEvent event) async {
    if (mounted) {
      ShadToaster.of(context).show(
        const ShadToast.destructive(
          title: Text('Uh oh! Something went wrong'),
          description: Text('Failed to log in. Please check your credentials and try again.'),
        ),
      );
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final state = context.select((AppBloc app) => app.state);

    return Column(
      children: [
        Expanded(
          child: TwoPane(
            startPane: const LeftPane(),
            paneProportion: 0.25,
            panePriority: switch (state) {
              AppState.comment || AppState.view => TwoPanePriority.both,
              AppState.disconnected || AppState.browse => TwoPanePriority.end,
            },
            endPane: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: switch (state) {
                  AppState.comment => Border.all(color: theme.colorScheme.border, width: 4),
                  _ => null,
                },
              ),
              child: RightPane(child: widget.child),
            ),
          ),
        ),
        const BottomPane(),
      ],
    );
  }
}
