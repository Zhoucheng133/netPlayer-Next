import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/components/sidebar_items.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  final Controller c = Get.put(Controller());
  final operations=Operations();

  Future<void> addPlayListHandler(BuildContext context) async {
    var newListName=TextEditingController();
    await showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: const Text('新建歌单'),
        content: TextField(
          controller: newListName,
          decoration: InputDecoration(
            isCollapsed: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)
          ),
          onEditingComplete: (){
            operations.addPlayList(context, newListName.text);
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('取消')
          ),
          ElevatedButton(
            onPressed: (){
              operations.addPlayList(context, newListName.text);
            }, 
            child: const Text('确定')
          )
        ],
      )
    );
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
          SideBarItem(name: 'albums'.tr, icon: Icons.album_rounded, index: 3,),
          SideBarItem(name: 'artists'.tr, icon: Icons.mic_rounded, index: 2,),
          SideBarItem(name: 'lovedSongs'.tr, icon: Icons.favorite_rounded, index: 1,),
          SideBarItem(name: 'allSongs'.tr, icon: Icons.queue_music_rounded, index: 0,),
          SideBarItem(name: 'search'.tr, icon: Icons.search_rounded, index: 5,),
          PlayListLabel(addPlayListHandler: () => addPlayListHandler(context),),
          const PlayListPart(),
          AccountPart(logoutHandler: () => logoutHandler(),),
        ],
      ),
    );
  }
}