import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatefulWidget {
  File imageFile;

  ViewPhoto({
    required this.imageFile,
  });

  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
              child: PhotoView(
            backgroundDecoration:
                BoxDecoration(color: Color.fromARGB(247, 0, 0, 0)),
            imageProvider: FileImage(widget.imageFile),
          )),
          Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, top: 10, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Ok"),
                  ),
                  onTap: () {},
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                    padding: const EdgeInsets.all(20.0),
                    child: Text("No"),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  iconSize: 24,
                  onPressed: () async {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.rotate_left,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                IconButton(
                  iconSize: 24,
                  onPressed: () async {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.rotate_right,
                    color: Colors.black,
                    size: 24,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
