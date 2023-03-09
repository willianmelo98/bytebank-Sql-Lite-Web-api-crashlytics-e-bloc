import 'dart:async';

import 'package:bytebankdatabase/widgets/app_dependencias.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/screens/apelido_user.dart';
import 'package:bytebankdatabase/screens/counter.dart';
import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:bytebankdatabase/widgets/tema_app.dart';

import 'http/webclients/transferencia_webclient.dart';

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
    runApp(Bytebank(
      contactDao: ContactDao(),
      transferenciaWebCliente: TransferenciaWebClient(),
    ));
  }, FirebaseCrashlytics.instance.recordError);
}

// ignore: use_key_in_widget_constructors
class Bytebank extends StatelessWidget {
  final ContactDao contactDao;

  final TransferenciaWebClient transferenciaWebCliente;
  const Bytebank(
      {Key? key,
      required this.contactDao,
      required this.transferenciaWebCliente})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppDependencias(
      transferenciaWebCliente: transferenciaWebCliente,
      contactDao: contactDao,
      child: MaterialApp(
        theme: tema,
        // ignore: prefer_const_constructors
        home: DashboardContainer(),
      ),
    );
  }
}
