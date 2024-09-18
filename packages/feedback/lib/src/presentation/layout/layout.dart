import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:feedback/feedback.dart';
import 'package:feedback/src/core/models/models.dart';
import 'package:feedback/src/presentation/bloc/app/app_bloc.dart';
import 'package:feedback/src/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:feedback/src/presentation/bloc/events/events.dart';
import 'package:feedback/src/presentation/bloc/devices/device_bloc.dart';
import 'package:feedback/src/presentation/components/avatar.dart';
import 'package:feedback/src/presentation/components/devices_button.dart';
import 'package:feedback/src/presentation/components/measurer.dart';
import 'package:feedback/src/presentation/components/panes.dart';
import 'package:feedback/src/presentation/components/theme.dart';
import 'package:feedback/src/presentation/layout/login.form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
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
              AppState.browse => TwoPanePriority.end,
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
