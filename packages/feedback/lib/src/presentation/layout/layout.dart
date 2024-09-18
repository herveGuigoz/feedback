import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/app/bloc/app_bloc.dart';
import 'package:feedback/src/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/presentation/authentication/components/avatar.dart';
import 'package:feedback/src/presentation/authentication/components/login_button.dart';
import 'package:feedback/src/presentation/devices/bloc/device_bloc.dart';
import 'package:feedback/src/presentation/devices/components/devices_button.dart';
import 'package:feedback/src/presentation/feedback/bloc/feedback_bloc.dart';
import 'package:feedback/src/presentation/feedback/views/feedback_form.dart';
import 'package:feedback/src/presentation/issues/components/index.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:feedback/src/presentation/shared/measurer.dart';
import 'package:feedback/src/presentation/shared/panes.dart';
import 'package:feedback/src/presentation/shared/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

part 'bottom.dart';
part 'left.dart';
part 'right.dart';

class FeedbackLayout extends StatelessWidget {
  const FeedbackLayout({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final state = context.select((AppBloc app) => app.state);

    return Column(
      children: [
        Expanded(
          child: TwoPane(
            startPane: const LeftPane(),
            paneProportion: 0.2,
            panePriority: switch (state) {
              AppState.comment || AppState.view => TwoPanePriority.both,
              AppState.disconnected || AppState.browse => TwoPanePriority.end,
            },
            endPane: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: switch (state) {
                  AppState.comment => Border.all(color: theme.primaryColor, width: 4),
                  _ => null,
                },
              ),
              child: RightPane(child: child),
            ),
          ),
        ),
        const BottomPane(),
      ],
    );
  }
}
