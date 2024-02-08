// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/playBar.dart';
import 'package:net_player_next/Views/mainViews/aboutView.dart';
import 'package:net_player_next/Views/mainViews/settingsView.dart';
import 'package:net_player_next/Views/mainViews/searchview.dart';

import '../functions/request.dart';
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

  Future<void> getPlayLists() async {
    // allListsRequest();
    // print(await allListsRequest());
    c.updateAllPlayList(await allListsRequest());
  }

  @override
  void initState() {
    super.initState();

    getPlayLists();
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
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: sideBar(),
        ),
        Expanded(
          child: Stack(
            children: [
              Obx(() => 
                IndexedStack(
                  index: getIndex(),
                  children: views,
                )
              ),
              Obx(() => 
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  bottom: c.showLyric.value ? -150 : 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40,0,40,10),
                      child: playBar(),
                    ),
                  ),
                )
              )
            ],
          )
        )
      ],
    );
  }
}