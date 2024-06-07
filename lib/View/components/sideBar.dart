// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:net_player_next/View/components/sideBarItems.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {

  void addPlayListHandler(){

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const sideBarItem(name: '专辑', icon: Icons.album_rounded, index: 2,),
          const sideBarItem(name: '艺人', icon: Icons.mic_rounded, index: 1,),
          const sideBarItem(name: '所有歌曲', icon: Icons.queue_music_rounded, index: 0,),
          const sideBarItem(name: '搜索', icon: Icons.search_rounded, index: 4,),
          playListLabel(addPlayListHandler: () => addPlayListHandler(),),
          const SizedBox(height: 5,),
          const Expanded(child: Placeholder())
        ],
      ),
    );
  }
}