// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '歌单: ', subTitle: '')
            ],
          )
        ],
      )
    );
  }
}