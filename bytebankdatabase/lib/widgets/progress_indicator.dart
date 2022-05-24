import 'package:flutter/material.dart';

class ProgressoCustomizado extends StatelessWidget {
  final String mensagemDoIndicator;

  ProgressoCustomizado({this.mensagemDoIndicator = 'Loading...'});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              mensagemDoIndicator,
              style: TextStyle(fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressoComScaffold extends StatelessWidget {
  final mensagem;

  const ProgressoComScaffold({Key? key, this.mensagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviando...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ProgressoCustomizado(
          mensagemDoIndicator: mensagem,
        ),
      ),
    );
  }
}
