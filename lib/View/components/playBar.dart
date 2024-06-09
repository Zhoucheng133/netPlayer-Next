// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class playBar extends StatefulWidget {
  const playBar({super.key});

  @override
  State<playBar> createState() => _playBarState();
}

class _playBarState extends State<playBar> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: c.color2,
      decoration: BoxDecoration(
        color: c.color4,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
      ),
    );
  }
}