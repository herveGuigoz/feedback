import 'dart:io';

import 'package:example/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = SelfSignedCertificateHttpOverrides();

  usePathUrlStrategy();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(App(sharedPreferences: sharedPreferences));
}

class SelfSignedCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
