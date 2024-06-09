// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class artistView extends StatefulWidget {
  const artistView({super.key});

  @override
  State<artistView> createState() => _artistViewState();
}

class _artistViewState extends State<artistView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '艺人', subTitle: '')
            ],
          )
        ],
      )
    );
  }
}