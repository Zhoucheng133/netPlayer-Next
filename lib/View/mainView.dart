// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/SideBar.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 150,
          child: sideBar(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10, top: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        )
      ],
    );
  }
}