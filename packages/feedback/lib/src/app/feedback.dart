import 'package:feedback/src/app/bloc/app_bloc.dart';
import 'package:feedback/src/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/devices/bloc/device_bloc.dart';
import 'package:feedback/src/feedbacks/create/bloc/feedback_form_bloc.dart';
import 'package:feedback/src/feedbacks/index/bloc/feedbacks_bloc.dart';
import 'package:feedback/src/layout/layout.dart';
import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FeedbackApp extends StatefulWidget {
  const FeedbackApp({
    required this.client,
    required this.routeInformationProvider,
    required this.child,
    super.key,
  });

  static Future<T?> showDialog<T>({required BuildContext context, required WidgetBuilder builder}) async {
    final state = context.findAncestorStateOfType<FeedbackAppState>()!;

    return state.showDialog<T>(context: context, builder: builder);
  }

  final FeedbackClient client;

  final RouteInformationProvider routeInformationProvider;

  final Widget child;

  @override
  State<FeedbackApp> createState() => FeedbackAppState();
}

class FeedbackAppState extends State<FeedbackApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  final _eventBus = EventBus();

  final _isDialogOpen = ValueNotifier(false);

  Future<T?> showDialog<T>({required BuildContext context, required WidgetBuilder builder}) async {
    _isDialogOpen.value = true;
    T? result;

    try {
      result = await showShadDialog<T>(context: navigatorKey.currentContext!, builder: builder);
    } finally {
      _isDialogOpen.value = false;
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    BrowserContextMenu.disableContextMenu();
  }

  @override
  void dispose() {
    _eventBus.close();
    _isDialogOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add a navigator to show dialogs above the app layout while keeping the child intact.
    final overlay = ValueListenableBuilder<bool>(
      valueListenable: _isDialogOpen,
      builder: (context, value, child) {
        return IgnorePointer(
          ignoring: !value,
          child: Navigator(
            key: navigatorKey,
            onGenerateInitialRoutes: (navigator, name) => [MaterialPageRoute(builder: (_) => Container())],
          ),
        );
      },
    );

    return MultiProvider(
      providers: [
        Provider<EventBus>.value(value: _eventBus),
        Provider<FeedbackClient>.value(value: widget.client),
      ],
      builder: (context, child) {
        return MultiProvider(
          providers: [
            BlocProvider(
              create: (_) => AppBloc(eventBus: context.read()),
            ),
            BlocProvider(
              create: (_) => AuthenticationBloc(null, eventBus: context.read(), client: widget.client),
            ),
            BlocProvider(
              create: (_) => DeviceBloc(eventBus: context.read()),
            ),
            BlocProvider(
              create: (context) => FeedbackFormBloc(eventBus: context.read(), client: widget.client),
            ),
            BlocProvider(
              create: (context) {
                return FeedbacksBloc(
                  client: widget.client,
                  eventBus: context.read(),
                  routeInformationProvider: widget.routeInformationProvider,
                );
              },
            ),
          ],
          child: child,
        );
      },
      child: ShadApp.custom(
        appBuilder: (context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: ShadAppBuilder(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: FeedbackLayout(child: widget.child),
                  ),
                  Positioned.fill(
                    child: overlay,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
