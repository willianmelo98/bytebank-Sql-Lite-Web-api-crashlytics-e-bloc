import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:bytebankdatabase/widgets/tema_app.dart';
import 'screens/dashboard/dashboard_container.dart';
import 'widgets/i18n/locale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    FirebaseCrashlytics.instance.setUserIdentifier("12345");
  }

  runZonedGuarded<Future<void>>(() async {
    runApp(Bytebank());
  }, FirebaseCrashlytics.instance.recordError);
}

// ignore: use_key_in_widget_constructors
class Bytebank extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: tema,
      // ignore: prefer_const_constructors
      home: LocalizationContainer(
        widget: DashboardContainer(),
      ),
    );
  }
}
