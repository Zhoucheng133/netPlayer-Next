// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class viewHeader extends StatefulWidget {

  final String title;
  final String subTitle;
  const viewHeader({super.key, required this.title, required this.subTitle});

  @override
  State<viewHeader> createState() => _viewHeaderState();
}

class _viewHeaderState extends State<viewHeader> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            color: c.color5,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}