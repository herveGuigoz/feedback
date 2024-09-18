import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class FadeGoRoute extends GoRoute {
  FadeGoRoute({
    required super.path,
    required super.name,
    required GoRouterWidgetBuilder builder,
    super.parentNavigatorKey,
    super.routes,
    super.redirect,
  }) : super(pageBuilder: (context, state) => FadePage(key: state.pageKey, name:name, child: builder(context, state)));
}

class FadePage<T> extends CustomTransitionPage<T> {
  const FadePage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
    super.transitionDuration = const Duration(milliseconds: 50),
  }) : super(transitionsBuilder: _transitionsBuilder);

  static Widget _transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(key: UniqueKey(), opacity: animation, child: child);
  }
}
