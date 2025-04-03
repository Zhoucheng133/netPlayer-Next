import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
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

  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  final operations=Operations();

  Future<void> addPlayListHandler(BuildContext context) async {
    var newListName=TextEditingController();
    await showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('addPlayList'.tr),
        content: TextField(
          controller: newListName,
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: "newListPlaceholder".tr,
            hintStyle: GoogleFonts.notoSansSc(
              color: Colors.grey[400],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorController.color3(), width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorController.color5(), width: 2.0),
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
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              operations.addPlayList(context, newListName.text);
            }, 
            child: Text('finish'.tr)
          )
        ],
      )
    );
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
    operations.stop();
    Map<String, Object> tmp={
      'id': '',
      'title': '',
      'artist': '',
      'playFrom': '',
      'duration': 0,
      'fromId': '',
      'album': '',
      'index': 0,
      'list': [],
    };
    c.nowPlay.value=tmp;
    c.userInfo.value={
      'url': null,
      'username': null,
      'salt': null,
      'token': null,
    };
    try {
      c.ws.stop();
    } catch (_) {}
  }

  Future<void> logoutHandler() async {
    await showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('logoutTitle'.tr),
        content: Text('logoutContent'.tr),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              logout();
              Navigator.pop(context);
            }, 
            child: Text('logout'.tr)
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