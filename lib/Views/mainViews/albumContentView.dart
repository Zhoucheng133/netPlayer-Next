// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../components/titleBar.dart';

class albumContentView extends StatefulWidget {
  const albumContentView({super.key});

  @override
  State<albumContentView> createState() => _albumContentViewState();
}

class _albumContentViewState extends State<albumContentView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBoxWithBack(subtitle: '测试副标题', title: '测试标题',)
        ],
      ),
    );
  }
}