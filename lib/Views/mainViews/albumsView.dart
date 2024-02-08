// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

class albumsView extends StatefulWidget {
  const albumsView({super.key});

  @override
  State<albumsView> createState() => _albumsViewState();
}

class _albumsViewState extends State<albumsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("专辑"),
    );
  }
}