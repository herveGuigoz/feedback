import 'dart:developer';

import 'package:feedback/src/adapters/api/api.dart';
import 'package:feedback/src/adapters/navigation/navigation_observer.dart';
import 'package:feedback/src/adapters/storage/storage.dart';
import 'package:feedback/src/domain/models/models.dart';
import 'package:feedback/src/presentation/app/bloc/app_bloc.dart';
import 'package:feedback/src/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/presentation/devices/bloc/device_bloc.dart';
import 'package:feedback/src/presentation/feedback/bloc/feedback_bloc.dart';
import 'package:feedback/src/presentation/issues/bloc/issues_bloc.dart';
import 'package:feedback/src/presentation/layout/layout.dart';
import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:feedback/src/presentation/shared/theme.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feedback extends StatefulWidget {
  const Feedback({
    required this.baseUrl,
    required this.projectId,
    required this.observer,
    required this.child,
    this.feedbackTheme = const FeedbackThemeData(),
    super.key,
  });

  static final _globalKey = GlobalKey();

  final String baseUrl;

  final String projectId;

  final FeedbackNavigationObserver observer;

  final FeedbackThemeData feedbackTheme;

  final Widget child;

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  late final ApiClientInterface _apiClient;
  late final StorageInterface _storage;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => EventBus(),
      child: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }

          _storage = PersistentStorage(sharedPreferences: snapshot.data!);
          _apiClient = ApiClient(baseUrl: widget.baseUrl, projectId: widget.projectId, storage: _storage);
          
          late final User? user;
          try {
            user = AuthenticationBloc.resolve(_storage);
          } catch (_) {
            log('Failed to resolve user from storage');
            user = null;
          }

          return MultiProvider(
            providers: [
              BlocProvider(
                create: (_) => AppBloc(
                  user != null ? AppState.browse : AppState.disconnected,
                  eventBus: context.read(),
                ),
              ),
              BlocProvider(
                create: (_) => AuthenticationBloc(
                  user,
                  eventBus: context.read(),
                  client: _apiClient,
                  storage: _storage,
                ),
              ),
              BlocProvider(
                create: (_) => DeviceBloc(eventBus: context.read()),
              ),
              BlocProvider(
                create: (context) => FeedbackFormBloc(eventBus: context.read(), apiClient: _apiClient),
              ),
              BlocProvider(
                create: (context) => FeedbacksBloc(
                  apiClient: _apiClient,
                  eventBus: context.read(),
                  navigationObserver: widget.observer,
                ),
              ),
            ],
            child: FeedbackTheme(
              // to remove when Shadcn UI is fully implemented
              data: widget.feedbackTheme,
              child: ShadApp.material(
                key: Feedback._globalKey,
                themeMode: ThemeMode.light,
                home: FeedbackLayout(child: widget.child),
                builder: (context, child) => Material(child: child),
              ),
            ),
          );
        },
      ),
    );
  }
}
