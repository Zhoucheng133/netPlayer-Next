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

  bool isSelected(String name, {String? id}){
    if(id!=null && name==c.nowPage['name'] && id==c.nowPage[id]){
      return true;
    }else if(name==c.nowPage['name']){
      return true;
    }
    return false;
  }

  void changePage(String val, {String? id}){
    c.updateNowPage(
      {
        "name": val,
        "id": id ?? "",
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 242, 242, 242),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          children: [
            Obx(() => sideBarMenu(menuName: "专辑", menuIcon: Icons.album_rounded, selected: isSelected("专辑"), changePage: (val) => changePage(val),),),
            Obx(() => sideBarMenu(menuName: "艺人", menuIcon: Icons.mic_rounded, selected: isSelected("艺人"), changePage: (val) => changePage(val),),),
            Obx(() => sideBarMenu(menuName: "所有歌曲", menuIcon: Icons.queue_music_rounded, selected: isSelected("所有歌曲"), changePage: (val) => changePage(val),),),
            Obx(() => sideBarMenu(menuName: "喜欢的歌曲", menuIcon: Icons.favorite_rounded, selected: isSelected("喜欢的歌曲"), changePage: (val) => changePage(val),),),
            Obx(() => sideBarMenu(menuName: "搜索", menuIcon: Icons.search_rounded, selected: isSelected("搜索"), changePage: (val) => changePage(val),),),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,)
          ],
        ),
      ),
    );
  }
}