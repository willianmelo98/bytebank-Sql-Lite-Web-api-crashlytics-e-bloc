import 'package:bytebankdatabase/widgets/i18n/i18n_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bytebankdatabase/model/name.dart';
import 'package:bytebankdatabase/screens/apelido_user.dart';
import 'package:bytebankdatabase/screens/contacts_list.dart';
import 'package:bytebankdatabase/screens/lista_transferencia.dart';
import 'package:bytebankdatabase/widgets/container.dart';

import '../../widgets/i18n/i18n_messages.dart';
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
}
