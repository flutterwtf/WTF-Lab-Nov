import 'dart:io';

import 'package:flutter/material.dart';

import 'message.dart';

class DetailsScreen extends StatefulWidget {
  final Message message;

  DetailsScreen(this.message);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.file(File(widget.message.imagePath)),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
