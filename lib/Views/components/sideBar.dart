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

  void toAbout(){
    c.updateNowPage({
      "name": "关于",
      "id": "",
    });
  }

  void toSettings(){
    c.updateNowPage({
      "name": "设置",
      "id": "",
    });
  }

  void addPlayList(){
    // TODO 添加歌单
    print("添加歌单");
  }

  void randomPlay(){
    // TODO 随机播放
    print("随机播放");
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
            SizedBox(height: 5,),
            Row(
              children: [
                Expanded(
                  child: sideBarMini(icon: Icons.add_rounded, func: addPlayList, isSelected: false,)
                ),
                SizedBox(width: 10,),
                Expanded(
                  // TODO 需要根据情况判定isSelected状态
                  child: sideBarMini(icon: Icons.shuffle_rounded, func: randomPlay, isSelected: false,)
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                SizedBox(width: 15,),
                Text(
                  "创建的歌单",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                )
              ],
            ),
            Expanded(
              child: Placeholder()
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: sideBarMini(icon: Icons.logout_rounded, func: logout, isSelected: false,)
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: sideBarMini(icon: Icons.settings_rounded, func: toSettings, isSelected: false,)
                )
              ],
            ),
            SizedBox(height: 5,),
            aboutTextButton(toAbout: toAbout,),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}