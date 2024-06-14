// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class lyricView extends StatefulWidget {
  const lyricView({super.key});

  @override
  State<lyricView> createState() => _lyricViewState();
}

class _lyricViewState extends State<lyricView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_left_rounded)
        ),
      ),
    );
  }
}