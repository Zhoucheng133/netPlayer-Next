// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class allView extends StatefulWidget {
  const allView({super.key});

  @override
  State<allView> createState() => _allViewState();
}

class _allViewState extends State<allView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '所有歌曲', subTitle: ''),
              songHeader(),
            ],
          )
        ],
      )
    );
  }
}