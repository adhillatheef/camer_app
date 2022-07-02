import 'dart:io';
import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  final String path;
  const FullScreen({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final File image = File(path);
    final String name = path.split('/').last;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(name),
      ),
      body: Center(
          child: Hero(
        tag: path,
        child: Image.file(image),
      )),
    );
  }
}
