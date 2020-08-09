import 'dart:io';
import 'package:flutter/material.dart';

class ShowClickedPicture extends StatelessWidget {
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
    );
  }
}
