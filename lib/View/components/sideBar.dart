// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/sideBarItems.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          sideBarItem(name: '专辑', icon: Icons.album_rounded, index: 2,),
          sideBarItem(name: '艺人', icon: Icons.mic_rounded, index: 1,),
          sideBarItem(name: '所有歌曲', icon: Icons.queue_music_rounded, index: 0,),
          sideBarItem(name: '搜索', icon: Icons.search_rounded, index: 4,)
        ],
      ),
    );
  }
}