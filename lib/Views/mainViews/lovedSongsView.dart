// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class lovedSongsView extends StatefulWidget {
  const lovedSongsView({super.key});

  @override
  State<lovedSongsView> createState() => _lovedSongsViewState();
}

class _lovedSongsViewState extends State<lovedSongsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("喜欢的歌曲"),
    );
  }
}