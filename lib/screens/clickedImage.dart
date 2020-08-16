import 'dart:io';
import 'package:flutter/material.dart';

class ShowClickedPicture extends StatelessWidget {
  static final String id = "Show_Clicked_Image";
  final imagePath;
  ShowClickedPicture({this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(
        File(imagePath),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "close",
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.clear),
          ),
          FloatingActionButton(
            heroTag: "ok",
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
