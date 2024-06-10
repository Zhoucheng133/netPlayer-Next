// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/variables/variables.dart';

class albumView extends StatefulWidget {
  const albumView({super.key});

  @override
  State<albumView> createState() => _albumViewState();
}

class _albumViewState extends State<albumView> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '专辑', subTitle: ''),
              albumHeader()
            ],
          )
        ],
      )
    );
  }
}