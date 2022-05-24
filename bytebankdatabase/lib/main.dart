import 'dart:async';

import 'package:bytebankdatabase/widgets/tema_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

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
      home: DashboardContainer(),
    );
  }
}

class testeContainerComBordaCurva extends StatelessWidget {
  const testeContainerComBordaCurva({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testes'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Image.network(
              "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 80,
            ),
            Container(
              padding: EdgeInsets.only(top: 220),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Container(
                  decoration: new BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(50.0),
                      )),
                  child: Column(
                    children: <Widget>[
                      Text("Hu"),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
