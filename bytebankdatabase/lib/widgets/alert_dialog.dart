import 'package:flutter/material.dart';

const Key transactionAuthDialogTextFieldPasswordKey =
    Key('transactionAuthDialogTextFieldPasswordKey');

class AlertAuthDialog extends StatefulWidget {
  final Function({@required String? senha})? login;

  AlertAuthDialog({this.login});
  @override
  State<AlertAuthDialog> createState() => _AlertAuthDialogState();
}

class _AlertAuthDialogState extends State<AlertAuthDialog> {
  final String titleString = 'Login';
  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleString),
      content: TextField(
        key: transactionAuthDialogTextFieldPasswordKey,
        controller: _valueController,
        maxLength: 4,
        obscureText: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 64, letterSpacing: 24),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              print('cancel');
            },
            child: const Text('Cancel')),
        ElevatedButton(
            onPressed: () {
              widget.login!(senha: _valueController.text);
              Navigator.pop(context);
            },
            child: const Text('confirm'))
      ],
    );
  }
}
