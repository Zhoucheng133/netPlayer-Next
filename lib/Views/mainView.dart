// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:net_player_next/Views/components/playBar.dart';
import 'package:net_player_next/Views/mainViews/aboutView.dart';
import 'package:net_player_next/Views/mainViews/lyricView.dart';
import 'package:net_player_next/Views/mainViews/settingsView.dart';
import 'package:net_player_next/Views/mainViews/searchview.dart';
import 'package:net_player_next/functions/operations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../paras/paras.dart';
import 'components/sideBar.dart';
import 'mainViews/albumsView.dart';
import 'mainViews/allSongsView.dart';
import 'mainViews/artistsView.dart';
import 'mainViews/lovedSongsView.dart';
import 'mainViews/playListView.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {

  final Controller c = Get.put(Controller());

  Future<void> registerHotKey() async {
    if(Platform.isWindows){
      HotKey nextSong = HotKey(
        KeyCode.arrowRight,
        scope: HotKeyScope.inapp,
        modifiers: [KeyModifier.control]
      );
      HotKey preSong = HotKey(
        KeyCode.arrowLeft,
        scope: HotKeyScope.inapp,
        modifiers: [KeyModifier.control]
      );
      HotKey toggle = HotKey(
        KeyCode.space,
        scope: HotKeyScope.inapp,
      );
      HotKey showLyric = HotKey(
        KeyCode.keyL,
        scope: HotKeyScope.inapp,
        modifiers: [KeyModifier.control]
      );
      HotKey nextsongGlobal=HotKey(
        KeyCode.arrowRight,
        scope: HotKeyScope.system,
        modifiers: [KeyModifier.control, KeyModifier.alt],
      );
      HotKey presongGlobal=HotKey(
        KeyCode.arrowLeft,
        scope: HotKeyScope.system,
        modifiers: [KeyModifier.control, KeyModifier.alt],
      );
      HotKey togglesongGlobal=HotKey(
        KeyCode.space,
        scope: HotKeyScope.system,
        modifiers: [KeyModifier.control, KeyModifier.alt],
      );
      await hotKeyManager.register(
        toggle,
        keyDownHandler: (hotKey) {
          if(!c.focusTextField.value){
            operations().toggleSong();
          }
        },
      );
      await hotKeyManager.register(
        nextSong,
        keyDownHandler: (_){
          operations().nextSong();
        }
      );
      await hotKeyManager.register(
        preSong,
        keyDownHandler: (_){
          operations().preSong();
        }
      );
      await hotKeyManager.register(
        showLyric,
        keyDownHandler: (hotkey) {
          c.updateShowLyric(!c.showLyric.value);
        }
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var globalShortcut=prefs.getBool('globalShortcut');
      if(globalShortcut!=false){
        await hotKeyManager.register(
          togglesongGlobal,
          keyDownHandler: (_){
            operations().toggleSong();
          }
        );
        await hotKeyManager.register(
          presongGlobal,
          keyDownHandler: (_){
            operations().preSong();
          }
        );
        await hotKeyManager.register(
          nextsongGlobal,
          keyDownHandler: (_){
            operations().nextSong();
          }
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    registerHotKey();
    operations().getPlayLists();
    operations().getLovedSongs();
    operations().getAlbums();
    operations().getArtist();
  }

  int getIndex(){
    return !indexVal.contains(c.nowPage['name']) ? 0 : indexVal.indexOf(c.nowPage['name']);
  }

  List<Widget> views=[
    albumsView(),
    artistsView(),
    allSongsView(),
    lovedSongsView(),
    searchView(),
    playListView(),
    settingsView(),
    aboutView(),
  ];

  List indexVal=[
    "专辑",
    "艺人",
    "所有歌曲",
    "喜欢的歌曲",
    "搜索",
    "歌单",
    "设置",
    "关于"
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: 200,
              child: sideBar(),
            ),
            Expanded(
              child: Obx(() => 
                IndexedStack(
                  index: getIndex(),
                  children: views,
                )
              ),
            )
          ],
        ),
        Obx(() => 
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: c.showLyric.value ? 0 : MediaQuery.of(context).size.height,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: lyricView(),
            ),
          ),
        ),
        Obx(() => 
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: 0,
            left: c.showLyric.value ? 0 : 200,
            right: 0,
            child: SizedBox(
              height: 110,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40,0,40,10),
                child: playBar(),
              ),
            ),
          )
        ),
      ],
    );
  }
}