import 'package:feedback/src/api/api.dart';
import 'package:feedback/src/components/theme.dart';
import 'package:feedback/src/core/devices.dart';
import 'package:feedback/src/core/events.dart';
import 'package:feedback/src/core/feedback.dart';
import 'package:feedback/src/core/observer.dart';
import 'package:feedback/src/layout/layout.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';

class Feedback extends StatefulWidget {
  const Feedback({
    required this.baseUrl,
    required this.apiToken,
    required this.observer,
    required this.child,
    this.feedbackTheme = const FeedbackThemeData(),
    super.key,
  });

  final String baseUrl;

  final String apiToken;

  final FeedbackNavigationObserver observer;

  final FeedbackThemeData feedbackTheme;

  final Widget child;

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EventsController(
            apiClient: ApiClient(baseUrl: widget.baseUrl, token: widget.apiToken),
            navigationObserver: widget.observer,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DeviceController(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => FeedbackController(eventsController: context.read<EventsController>()),
        child: FeedbackTheme(
          data: widget.feedbackTheme,
          child: WidgetsApp(
            color: widget.feedbackTheme.primaryColor,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
            ],
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => builder(context),
            ),
            home: FeedbackLayout(child: widget.child),
            builder: (context, child) => Material(child: child),
          ),
        ),
      ),
    );
  }
}
