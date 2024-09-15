import 'dart:async';
import 'dart:ui' as ui;

import 'package:feedback/feedback.dart';
import 'package:feedback/src/components/avatar.dart';
import 'package:feedback/src/components/devices_button.dart';
import 'package:feedback/src/components/measurer.dart';
import 'package:feedback/src/components/panes.dart';
import 'package:feedback/src/components/theme.dart';
import 'package:feedback/src/core/devices.dart';
import 'package:feedback/src/core/events.dart';
import 'package:feedback/src/core/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final controller = context.watch<FeedbackController>();

    return Column(
      children: [
        Expanded(
          child: TwoPane(
            startPane: const LeftPane(),
            paneProportion: 0.2,
            panePriority: switch (controller.state) {
              FeedbackState.comment || FeedbackState.view => TwoPanePriority.both,
              FeedbackState.browse => TwoPanePriority.end,
            },
            endPane: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                border: switch (controller.state) {
                  FeedbackState.comment => Border.all(color: theme.primaryColor, width: 4),
                  _ => null,
                },
              ),
              child: RightPane(controller: controller, child: child),
            ),
          ),
        ),
        const BottomPane(),
      ],
    );
  }
}
