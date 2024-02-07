// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/sideBarMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../paras/paras.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {

  final Controller c = Get.put(Controller());

  Future<void> logout() async {
    c.updateUserInfo({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 242, 242, 242),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: [
            sideBarMenu(menuName: "专辑", menuIcon: Icons.album_rounded, selected: false),
            sideBarMenu(menuName: "艺人", menuIcon: Icons.mic_rounded, selected: false),
            sideBarMenu(menuName: "所有歌曲", menuIcon: Icons.queue_music_rounded, selected: false),
            sideBarMenu(menuName: "喜欢的歌曲", menuIcon: Icons.favorite_rounded, selected: false),
            sideBarMenu(menuName: "搜索", menuIcon: Icons.search_rounded, selected: false),
          ],
        ),
      ),
    );
  }
}