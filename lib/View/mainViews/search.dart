// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '搜索', subTitle: '')
            ],
          )
        ],
      )
    );
  }
}