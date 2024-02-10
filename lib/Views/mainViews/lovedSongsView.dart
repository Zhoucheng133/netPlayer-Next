// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../functions/operations.dart';
import '../../paras/paras.dart';
import '../components/listItems.dart';
import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class lovedSongsView extends StatefulWidget {
  const lovedSongsView({super.key});

  @override
  State<lovedSongsView> createState() => _lovedSongsViewState();
}

class _lovedSongsViewState extends State<lovedSongsView> {

  final Controller c = Get.put(Controller());

  void search(value){
    // TODO 搜索歌曲
  }

  void reload(){
    // TODO 刷新列表
  }

  void playSongFromLovedSongs(int index){
    // TODO 播放歌曲
  }

  TextEditingController searchInput=TextEditingController();

  var controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => titleBox(searchController: search, title: "喜欢的歌曲", subtitle: "合计${c.lovedSongs.length}首歌", controller: searchInput, reloadList: () => reload(),)),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.lovedSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return index==c.lovedSongs.length-1 ? 
                  Column(
                    children: [
                      songItem(artist: c.lovedSongs[index]["artist"], duration: c.lovedSongs[index]["duration"], index: index, title: c.lovedSongs[index]["title"], isLoved: operations().isLoved(c.lovedSongs[index]["id"]), playSong: ()=>playSongFromLovedSongs(index),),
                      SizedBox(height: 120,),
                    ],
                  ):
                  songItem(artist: c.lovedSongs[index]["artist"], duration: c.lovedSongs[index]["duration"], index: index, title: c.lovedSongs[index]["title"], isLoved: operations().isLoved(c.lovedSongs[index]["id"]), playSong: ()=>playSongFromLovedSongs(index),);
                }
              )
            )
          )
        ],
      ),
    );
  }
}