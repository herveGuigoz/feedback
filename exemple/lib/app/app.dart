import 'package:example/app/route.dart';
import 'package:example/blog/blog.dart';
import 'package:example/counter/counter.dart';
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
      projectId: '1ef76713-698a-61d4-8018-07d57344ecd9',
      baseUrl: 'http://localhost',
      observer: observer,
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
