import 'dart:async';

import 'package:bytebankdatabase/http/webclients/transferencia_webclient.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:bytebankdatabase/widgets/alert_dialog.dart';
import 'package:bytebankdatabase/widgets/giff_dialog.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';
import 'package:bytebankdatabase/widgets/response_dialog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransferenciaWebClient transferenciaWebCliente =
      TransferenciaWebClient();
  final String uuid = Uuid().v4();

  bool _mostrarProgresso = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (contextDialog) => AlertAuthDialog(
                                login: ({senha}) {
                                  _saveTransacao(senha, context);
                                },
                              ));
                    },
                  ),
                ),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProgressoCustomizado(
                    mensagemDoIndicator: 'Realizando Transferencia ',
                  ),
                ),
                visible: _mostrarProgresso,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTransacao(String? senha, BuildContext context) async {
    final double? value = double.tryParse(_valueController.text);
    final transactionCreated = Transferencia(uuid, value, widget.contact);
    Transferencia transferenciaEnviada =
        await _sendNewTransafer(transactionCreated, senha, context);

    if (transferenciaEnviada != null) {
      _sucessoTransferencia(context);
    }
  }

  Future<void> _sucessoTransferencia(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (contextDialogSucess) => SuccessDialog('Transacao efetuada'),
    );
    Navigator.of(context).pop();
  }

  Future<Transferencia> _sendNewTransafer(Transferencia transactionCreated,
      String? senha, BuildContext context) async {
    setState(() {
      _mostrarProgresso = true;
    });
    Transferencia transferenciaEnviada = await transferenciaWebCliente
        .save(transactionCreated, senha!)
        .catchError((e) {
      _showMenssagemErro(context, message: e.message);
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is HttpException).catchError((e) {
      _showMenssagemErro(context, message: 'Time Out');
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showMenssagemErro(context);

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is Exception).whenComplete(
      () => setState(() {
        _mostrarProgresso = false;
      }),
    );
    return transferenciaEnviada;
  }

  void _showMenssagemErro(BuildContext context,
      {String message = 'Erro desconhecido'}) {
    showDialog(
        context: context,
        builder: (_) => GifDialog(
              okBtn: () {
                Navigator.of(context).pop();
              },
              message: message,
            ));

    //ToastContext().init(context);
    //showToast(message, gravity: Toast.bottom);

    //final snackbar = SnackBar(content: Text(message));
    //ScaffoldMessenger.of(context).showSnackBar(snackbar);

    //return showDialog(
    //  context: context,
    //  builder: (contextDialog) => FailureDialog(message),
    //);
  }

  void showToast(String msg, {int? duration = 5, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
