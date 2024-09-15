import 'dart:io';

import 'package:example/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  HttpOverrides.global = SelfSignedCertificateHttpOverrides();

  usePathUrlStrategy();

  runApp(const App());
}

class SelfSignedCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (cert, host, port) => true;
  }
}
