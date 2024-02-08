// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../paras/paras.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => Text("歌单: ${c.nowPage['id']}")),
    );
  }
}