import 'package:example/app/route.dart';
import 'package:example/blog/blog.dart';
import 'package:example/counter/counter.dart';
import 'package:feedback/feedback.dart';
import 'package:feedback_pocketbase/feedback_pocketbase.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({required this.sharedPreferences, super.key});

  static final _globalKey = GlobalKey();

  final SharedPreferences sharedPreferences;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final client = FeedbackPocketbase(
    baseUrl: 'http://localhost:8080',
    projectId: 'e8s03yzyq9fxgim',
    storage: FeedbackStorage(sharedPreferences: widget.sharedPreferences),
  );

  late final router = GoRouter(
    routes: [
      FadeGoRoute(
        path: '/',
        name: 'Home',
        builder: (context, state) => const CounterPage(title: 'couter'),
      ),
      FadeGoRoute(path: '/blog', name: 'blog', builder: (context, state) => const BlogPage()),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      key: App._globalKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) => FeedbackApp(
        client: client,
        routeInformationProvider: router.routeInformationProvider,
        child: child!,
      ),
    );
  }
}

class FeedbackStorage implements FeedbackStorageInterface {
  FeedbackStorage({required SharedPreferences sharedPreferences}) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  String? read(String key) => _sharedPreferences.getString(key);

  @override
  Future<void> write({required String key, required String value, Duration? expireIn}) {
    return _sharedPreferences.setString(key, value);
  }

  @override
  Future<void> delete(String key) => _sharedPreferences.remove(key);
}
