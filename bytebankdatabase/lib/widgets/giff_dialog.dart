import 'package:flutter/material.dart';
import 'package:giff_dialog/giff_dialog.dart';

class GifDialog extends StatelessWidget {
  Function? okBtn;
  String message;
  GifDialog({this.okBtn, this.message = ""}) : assert(okBtn != null);

  @override
  Widget build(BuildContext context) {
    return NetworkGiffDialog(
      image: Image.network(
        "https://raw.githubusercontent.com/Shashank02051997/FancyGifDialog-Android/master/GIF's/gif14.gif",
        fit: BoxFit.fitHeight,
      ),
      title: Text(
        'Ops',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
      ),
      description: Text(
        message,
        textAlign: TextAlign.center,
      ),
      entryAnimation: EntryAnimation.topLeft,
      onOkButtonPressed: () {
        okBtn!();
      },
      onlyOkButton: true,
    );
  }
}
