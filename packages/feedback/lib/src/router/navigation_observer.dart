// typedef ScreenNameExtractor = String? Function(RouteSettings settings);

// String? defaultNameExtractor(RouteSettings settings) => settings.name;

// class FeedbackNavigationObserver extends RouteObserver<ModalRoute<dynamic>> with ChangeNotifier {
//   FeedbackNavigationObserver();

//   RouteSettings? _current;

//   void didChange(RouteSettings route) {
//     if (route == _current) return;
//     _current = route;
//     notifyListeners();
//   }

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPush(route, previousRoute);
//     didChange(route.settings);
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
//     if (newRoute != null) didChange(newRoute.settings);
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     super.didPop(route, previousRoute);
//     if (previousRoute != null) didChange(previousRoute.settings);
//   }
// }
