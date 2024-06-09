// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/viewHead.dart';

class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '设置', subTitle: '')
            ],
          )
        ],
      )
    );
  }
}