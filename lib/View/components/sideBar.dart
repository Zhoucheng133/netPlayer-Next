// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/sideBarItems.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {

  final Controller c = Get.put(Controller());

  void addPlayListHandler(){
    // TODO 添加歌单
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
    c.userInfo.value={
      'url': null,
      'username': null,
      'salt': null,
      'token': null,
    };
  }

  Future<void> logoutHandler() async {
    await showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: const Text('注销当前账户?'),
        content: const Text('注销后会回到登录页面'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('取消')
          ),
          ElevatedButton(
            onPressed: (){
              logout();
              // final SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.pop(context);
            }, 
            child: const Text('继续')
          )
        ],
      )
    );
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
          // const Expanded(child: Placeholder()),
          const PlayListPart(),
          AccountPart(logoutHandler: () => logoutHandler(),),
        ],
      ),
    );
  }
}