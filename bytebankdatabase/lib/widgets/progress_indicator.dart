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
