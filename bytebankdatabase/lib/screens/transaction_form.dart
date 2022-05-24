import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import 'package:bytebankdatabase/http/webclients/transferencia_webclient.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:bytebankdatabase/widgets/alert_dialog.dart';
import 'package:bytebankdatabase/widgets/container.dart';
import 'package:bytebankdatabase/widgets/giff_dialog.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';
import 'package:bytebankdatabase/widgets/response_dialog.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  final String message;
  final BuildContext context;
  const FatalErrorTransactionFormState(
    this.context, {
    required this.message,
  });
}

//
//
//Cubit

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());
  final TransferenciaWebClient transferenciaWebCliente =
      TransferenciaWebClient();

  void _saveTransacao(String? senha, Transferencia transactionCreated,
      BuildContext context) async {
    emit(SendingState());
    Transferencia transferenciaEnviada =
        await _sendNewTransafer(transactionCreated, senha, context);

    if (transferenciaEnviada != null) {
      emit(SentState());
    }
  }

  Future<Transferencia> _sendNewTransafer(Transferencia transactionCreated,
      String? senha, BuildContext context) async {
    Transferencia transferenciaEnviada = await transferenciaWebCliente
        .save(transactionCreated, senha!)
        .catchError((e) {
      emit(FatalErrorTransactionFormState(context, message: e.message));
      //  _showMenssagemErro(context, message: e.message);

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is HttpException).catchError((e) {
      // _showMenssagemErro(context, message: 'Time Out');
      emit(FatalErrorTransactionFormState(context, message: 'Time Out'));

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is TimeoutException).catchError((e) {
      // _showMenssagemErro(context);

      emit(FatalErrorTransactionFormState(context, message: e.message));

      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.recordError(e.message, null);
        FirebaseCrashlytics.instance
            .setCustomKey('Objeto do erro: ', transactionCreated);
      }
    }, test: (e) => e is Exception);
    return transferenciaEnviada;
  }
}

//
//
//BlocContainer
//
class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (BuildContext context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if (state is SentState) {
            _sucessoTransferencia(context);
          }
          if (state is FatalErrorTransactionFormState) {
            _showMenssagemErro(context, message: state.message);
          }
        },
        child: TransactionForm(_contact),
      ),
    );
  }
}

//
//
//Telas de acordo com estado
class TransactionForm extends StatelessWidget {
  final Contact contact;

  TransactionForm(this.contact);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState || state is FatalErrorTransactionFormState) {
        return BasicForm(
          contact: contact,
        );
      }
      if (state is SendingState || state is SentState) {
        return ProgressoComScaffold(
          mensagem: "Efetuando a Transferencia",
        );
      }

      return const Text("Erro");
    });
  }
}

//
//
//Pag form construida
class BasicForm extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();

  final String uuid = Uuid().v4();

  final Contact contact;
  BasicForm({required this.contact});

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
                contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  contact.accountNumber.toString(),
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
                                  final double? value =
                                      double.tryParse(_valueController.text);
                                  final transactionCreated =
                                      Transferencia(uuid, value, contact);
                                  context
                                      .read<TransactionFormCubit>()
                                      ._saveTransacao(
                                          senha, transactionCreated, context);
                                },
                              ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _sucessoTransferencia(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (contextDialogSucess) => SuccessDialog('Transacao efetuada'),
  );
  Navigator.of(context).pop();
}

void _showMenssagemErro(BuildContext context,
    {String message = 'Erro desconhecido'}) {
  showDialog(
      context: context,
      builder: (_) => GifDialog(
          okBtn: () {
            Navigator.of(context).pop();
          },
          message: message));

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
