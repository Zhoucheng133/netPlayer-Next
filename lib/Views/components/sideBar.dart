// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'package:fluent_ui/fluent_ui.dart';


import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/sideBarMenu.dart';
import 'package:net_player_next/functions/operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../paras/paras.dart';

class sideBar extends StatefulWidget {
  const sideBar({super.key});

  @override
  State<sideBar> createState() => _sideBarState();
}

class _sideBarState extends State<sideBar> {

  final Controller c = Get.put(Controller());

  ScrollController playlistScroll=ScrollController();

  Future<void> logout() async {

    await showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("注销当前账户?"),
          content: Text("这会停止播放并且回到登录界面"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("取消")
            ),
            FilledButton(
              onPressed: () async {
                c.updateUserInfo({});
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userInfo');
                Navigator.pop(context);
              }, 
              child: Text("注销")
            ),
          ],
        );
      }
    );
  }

  bool isSelected(String name, {String? id}){
    if(id!=null && c.nowPage['name']=="歌单" && id==c.nowPage['id']){
      return true;
    }else if(name==c.nowPage['name'] && c.nowPage['name']!="歌单"){
      return true;
    }
    return false;
  }

  void changePage(Map val){
    Map<String, String> data={
      "name": val["name"],
      "id": val["id"] ?? "",
    };

    c.updateNowPage(data);
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

  @override
  void initState() {
    super.initState();

    textfocus.addListener(() { 
      if(textfocus.hasFocus){
        c.updateFocusTextField(true);
      }else{
        c.updateFocusTextField(false);
      }
    });
  }

  FocusNode textfocus=FocusNode();

  Future<void> addListController(String title, BuildContext context) async {
    var val=await operations().addList(title);
    if(val){
      showFlash(
        duration: const Duration(milliseconds: 1500),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200), 
        builder: (context, controller) => FlashBar(
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          backgroundColor: Colors.green[400],
          iconColor: Colors.white,
          margin: EdgeInsets.only(
            top: 30,
            left: (MediaQuery.of(context).size.width-280)/2,
            right: (MediaQuery.of(context).size.width-280)/2
          ),
          icon: Icon(
            Icons.close,
          ),
          controller: controller, 
          content: Text(
            "添加成功",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        context: context
      );
    }else{
      showFlash(
        duration: const Duration(milliseconds: 1500),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200), 
        builder: (context, controller) => FlashBar(
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          backgroundColor: Colors.red,
          iconColor: Colors.white,
          margin: EdgeInsets.only(
            top: 30,
            left: (MediaQuery.of(context).size.width-280)/2,
            right: (MediaQuery.of(context).size.width-280)/2
          ),
          icon: Icon(
            Icons.close,
          ),
          controller: controller, 
          content: Text(
            "添加失败",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        context: context
      );
    }
  }

  Future<void> addPlayList(BuildContext context) async {
    var controller=TextEditingController();

    await showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text("添加歌单"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("歌单名称:"),
            SizedBox(height: 10,),
            TextField(
              focusNode: textfocus,
              controller: controller,
              style: TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: c.hoverColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 210, 210, 210),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("取消")
          ),
          FilledButton(
            onPressed: () async {
              if(controller.text==""){
                showFlash(
                  duration: const Duration(milliseconds: 1500),
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 200), 
                  builder: (context, controller) => FlashBar(
                    behavior: FlashBehavior.floating,
                    position: FlashPosition.top,
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    margin: EdgeInsets.only(
                      top: 30,
                      left: (MediaQuery.of(context).size.width-280)/2,
                      right: (MediaQuery.of(context).size.width-280)/2
                    ),
                    icon: Icon(
                      Icons.close,
                    ),
                    controller: controller, 
                    content: Text(
                      "歌单名称不能为空",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  context: context
                );
              }else{
                await addListController(controller.text, context);
                Navigator.pop(context);
              }
            }, 
            child: Text("完成")
          )
        ],
      )
    );
  }

  void randomPlay(){
    // TODO 随机播放
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
                  child: GestureDetector(child: sideBarMini(icon: Icons.add_rounded, func: (){addPlayList(context);}, isSelected: false,))
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
            SizedBox(height: 5,),
            Expanded(
              child: Scrollbar(
                controller: playlistScroll,
                thumbVisibility: false,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: Obx(() => 
                    ListView.builder(
                      controller: playlistScroll,
                      itemCount: c.allPlayList.length,
                      itemBuilder: (BuildContext context, int index) => Obx(() => sideBarMenu(menuName: c.allPlayList[index]["name"], menuIcon: Icons.playlist_play_rounded, selected: isSelected("歌单", id: c.allPlayList[index]["id"]), changePage: (val) => changePage(val),id: c.allPlayList[index]["id"],))
                    )
                  ),
                ),
              )
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