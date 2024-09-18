import 'dart:developer';

import 'package:feedback/src/core/api/api.dart';
import 'package:feedback/src/core/navigation/navigation_observer.dart';
import 'package:feedback/src/core/storage/storage.dart';
import 'package:feedback/src/presentation/bloc/app/app_bloc.dart';
import 'package:feedback/src/presentation/bloc/authentication/authentication_bloc.dart';
import 'package:feedback/src/presentation/bloc/devices/device_bloc.dart';
import 'package:feedback/src/presentation/components/theme.dart';
import 'package:feedback/src/presentation/layout/layout.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final ApiClient _apiClient;
  late final Storage _storage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }

        _storage = PersistentStorage(sharedPreferences: snapshot.data!);
        _apiClient = ApiClient(baseUrl: widget.baseUrl, projectId: widget.projectId, storage: _storage);

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AppBloc(),
            ),
            BlocProvider(
              create: (_) => AuthenticationBloc(client: _apiClient, storage: _storage)..add(const AppLaunchedEvent()),
            ),
            BlocProvider(
              create: (_) => DeviceBloc(),
            ),
          ],
          child: FeedbackTheme(
            // TODO remove
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
    );
  }
}
