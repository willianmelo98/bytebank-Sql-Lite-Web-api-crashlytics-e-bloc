import 'dart:io';

import 'package:bytebankdatabase/main.dart';
import 'package:bytebankdatabase/screens/counter.dart';
import 'package:bytebankdatabase/widgets/ViewPhoto.dart';
import 'package:bytebankdatabase/widgets/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bytebankdatabase/model/name.dart';
import 'package:bytebankdatabase/screens/apelido_user.dart';
import 'package:bytebankdatabase/screens/contact/contacts_list.dart';
import 'package:bytebankdatabase/screens/transferencia/lista_transferencia.dart';
import 'package:bytebankdatabase/widgets/container.dart';

import '../../widgets/camera/camera2.dart';
import '../../widgets/camera/camera3/camera_screen.dart';
import '../video.dart';
import 'dashboard_i18n.dart';
import 'dashboard_item.dart';

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N? _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text('Bem vindo, $state '),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FeatureItem(
                  _i18n!.transfer,
                  Icons.monetization_on,
                  onClick: () {
                    _showContactsList(context);
                  },
                ),
                FeatureItem(
                  _i18n!.transfers,
                  Icons.description,
                  onClick: () {
                    _showTransactionsList(context);
                  },
                ),
                FeatureItem(
                  _i18n!.changeName,
                  Icons.person_outlined,
                  onClick: () {
                    _showName(context);
                  },
                ),
                FeatureItem(
                  "Camera 1",
                  Icons.video_call_outlined,
                  onClick: () {
                    _showACamera1(context);
                  },
                ),
                FeatureItem(
                  "Camera 2",
                  Icons.video_call_outlined,
                  onClick: () {
                    _showACamera2(context);
                  },
                ),
                FeatureItem(
                  "Camera 3",
                  Icons.video_call_outlined,
                  onClick: () {
                    _showACamera3(context);
                  },
                ),
                FeatureItem(
                  "Counter",
                  Icons.video_call_outlined,
                  onClick: () {
                    _counter(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactsList(BuildContext blocContext) {
    push(blocContext, ContactsListContainer());
  }

  void _showName(BuildContext blocContext) {
    Navigator.of(blocContext).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }

  void _showTransactionsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListaTransferencias(),
      ),
    );
  }

  void _showACamera2(BuildContext context) {
    final firstCamera = cameras.first;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          camera: firstCamera,
        ),
      ),
    );
  }

  void _showACamera1(BuildContext context) {
    final firstCamera = cameras.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraExampleHome(),
      ),
    );
  }

  void _showACamera3(BuildContext context) {
    final firstCamera = cameras.first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(),
      ),
    );
  }

  void _counter(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CountContainer(),
      ),
    );
  }
}
