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
  const FeedbackApp({required this.client, required this.routeInformationProvider, required this.child, super.key});

  final FeedbackClient client;

  final RouteInformationProvider routeInformationProvider;

  final Widget child;

  @override
  State<FeedbackApp> createState() => FeedbackAppState();
}

class FeedbackAppState extends State<FeedbackApp> {
  @override
  void initState() {
    super.initState();
    BrowserContextMenu.disableContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FeedbackClient>.value(value: widget.client),
        Provider<EventBus>(create: (_) => EventBus()),
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: const [DefaultMaterialLocalizations.delegate, DefaultWidgetsLocalizations.delegate],
          child: Material(
            child: StreamBuilder<User?>(
              stream: widget.client.user,
              builder: (context, snapshot) {
                return switch (snapshot.connectionState) {
                  ConnectionState.none || ConnectionState.waiting => const CircularProgressIndicator.adaptive(),
                  _ => MultiProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => AppBloc(
                          snapshot.data != null ? AppState.browse : AppState.disconnected,
                          eventBus: context.read(),
                        ),
                      ),
                      BlocProvider(
                        create: (_) =>
                            AuthenticationBloc(snapshot.data, eventBus: context.read(), client: widget.client),
                      ),
                      BlocProvider(create: (_) => DeviceBloc(eventBus: context.read())),
                      BlocProvider(
                        create: (context) => FeedbackFormBloc(eventBus: context.read(), client: widget.client),
                      ),
                      BlocProvider(
                        create: (context) => FeedbacksBloc(
                          client: widget.client,
                          eventBus: context.read(),
                          routeInformationProvider: widget.routeInformationProvider,
                        ),
                      ),
                    ],
                    child: ShadTheme(
                      data: ShadThemeData(
                        brightness: Brightness.light,
                        colorScheme: const ShadSlateColorScheme.light(),
                      ),
                      child: ShadToaster(
                        child: Navigator(
                          onGenerateInitialRoutes: (navigator, initialRoute) => [
                            MaterialPageRoute(builder: (context) => FeedbackLayout(child: widget.child)),
                          ],
                        ),
                      ),
                    ),
                  ),
                };
              },
            ),
          ),
        ),
      ),
    );
  }
}
