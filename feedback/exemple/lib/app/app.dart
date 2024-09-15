import 'package:example/app/route.dart';
import 'package:example/blog/blog.dart';
import 'package:example/counter/counter.dart';
import 'package:example/shared/body.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:go_router/go_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final observer = FeedbackNavigationObserver();

  late final router = GoRouter(
    observers: [
      observer,
    ],
    routes: [
      FadeGoRoute(
        path: '/',
        name: 'Home',
        builder: (context, state) => const CounterPage(title: 'couter'),
      ),
      FadeGoRoute(
        path: '/blog',
        name: 'blog',
        builder: (context, state) => const BlogPage(),
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Feedback(
      apiToken: '9217ca77-d5e7-4f68-a61f-841bad10df49',
      baseUrl: 'http://localhost',
      observer: observer,
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
        builder: (context, child) => PageBody(child: child),
      ),
    );
  }
}
