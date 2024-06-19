// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/SideBar.dart';
import 'package:net_player_next/View/components/playBar.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/View/mainViews/album.dart';
import 'package:net_player_next/View/mainViews/all.dart';
import 'package:net_player_next/View/mainViews/artist.dart';
import 'package:net_player_next/View/mainViews/loved.dart';
import 'package:net_player_next/View/mainViews/playList.dart';
import 'package:net_player_next/View/mainViews/search.dart';
import 'package:net_player_next/View/mainViews/settings.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {

  final Controller c = Get.put(Controller());
  late Worker listener;
  
  // 是否保存->(是)加载播放信息->是否后台播放->是否所有歌曲随机播放->是否启用全局快捷键->是否自定义播放模式
  Future<void> initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savePlay=prefs.getBool('savePlay');
    if(savePlay!=false){
      final nowPlay=prefs.getString('nowPlay');
      if(nowPlay!=null){
        Map<String, dynamic> decodedMap = jsonDecode(nowPlay);
        Map<String, Object> tmpList=Map<String, Object>.from(decodedMap);
        c.nowPlay.value=tmpList;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Operations().nowPlayCheck(context);
        });
      }
    }else{
      c.savePlay.value=false;
    }
    final closeOnRun=prefs.getBool('closeOnRun');
    if(closeOnRun==false){
      c.closeOnRun.value=false;
    }
    final fullRandomPlay=prefs.getBool('fullRandom');
    if(fullRandomPlay==true && savePlay!=false){
      c.fullRandom.value=true;
    }
    final useShortcut=prefs.getBool('useShortcut');
    if(useShortcut==false){
      c.useShortcut.value=false;
    }
    final playMode=prefs.getString('playMode');
    if(playMode!=null && playMode!='list'){
      c.playMode.value=playMode;
    }
    final volume=prefs.getInt('volume');
    if(volume!=null && volume!=100){
      c.volume.value=volume;
    }
    Operations().initHotkey(context);
  }

  Future<void> nowplayChange(Map val) async {
    // 保存现在播放的内容
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nowPlay', jsonEncode(val));
    c.lyricLine.value=0;
    // 如果id不为空，获取歌词
    c.lyric.value=[
      {
        'time': 0,
        'content': '查找歌词中...',
      }
    ];
    if(val['id']!=''){
      Operations().getLyric();
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    listener=ever(c.nowPlay, (val)=>nowplayChange(val));
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 150,
                child: sideBar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(()=>
                      IndexedStack(
                        index: c.pageIndex.value,
                        children: const [
                          allView(),
                          lovedView(),
                          artistView(),
                          albumView(),
                          playListView(),
                          searchView(),
                          settingsView()
                        ],
                      )
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        const SizedBox(
          height: 80,
          child: playBar(),
        )
      ],
    );
  }
}