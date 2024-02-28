// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 130),
        child: Container(color: Colors.red,),
      ),
    );
  }
}