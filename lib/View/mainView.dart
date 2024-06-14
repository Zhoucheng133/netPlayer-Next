// ignore_for_file: file_names, camel_case_types

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
  
  // 是否保存->(是)加载播放信息->是否后台播放->是否启用全局快捷键->是否自定义播放模式
  Future<void> initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savePlay=prefs.getBool('savePlay');
    if(savePlay!=false){
      final nowPlay=prefs.getString('nowPlay');
      if(nowPlay!=null){
        Map<String, dynamic> decodedMap = jsonDecode(nowPlay);
        Map<String, Object> tmpList=Map<String, Object>.from(decodedMap);
        c.nowPlay.value=tmpList;
        c.nowPlay.refresh();
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
    Operations().initHotkey();
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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