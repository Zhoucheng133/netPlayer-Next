// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/functions/operations.dart';

import '../../paras/paras.dart';
import '../components/listItems.dart';
import '../components/titleBar.dart';

class albumContentView extends StatefulWidget {
  const albumContentView({super.key});

  @override
  State<albumContentView> createState() => _albumContentViewState();
}

class _albumContentViewState extends State<albumContentView> {

  final Controller c = Get.put(Controller());

  final ScrollController controller=ScrollController();

  void playFromAlbum(int index){
    operations().playSong("专辑", c.nowPage["id"]??"", index, c.albumContentData["list"]);
  }

  bool isPlaying(index){
    if(c.playInfo["playFrom"]!="专辑"){
      return false;
    }else{
      if(c.playInfo["index"]==index && c.playInfo["listId"]==c.nowPage["id"]){
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => titleBoxWithBack(title: "专辑: ${c.albumContentData["title"]??''}", subtitle: "含有歌曲${c.albumContentData["list"]==null?'0':c.albumContentData["list"].length}首",),),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            child: Obx(() => 
              c.albumContentData.isNotEmpty ?
              ListView.builder(
                controller: controller,
                itemCount: c.albumContentData["list"].length,
                itemBuilder: (BuildContext context, int index){
                  return index==c.albumContentData["list"].length-1 ? Column(
                    children: [
                      Obx(() => 
                        songItem(
                          artist: c.albumContentData["list"][index]["artist"], 
                          duration: c.albumContentData["list"][index]["duration"], 
                          index: index, 
                          title: c.albumContentData["list"][index]["title"], 
                          isLoved: operations().isLoved(c.albumContentData["list"][index]["id"]), 
                          playSong: ()=>playFromAlbum(index), 
                          isPlaying: isPlaying(index), 
                          id: c.albumContentData["list"][index]["id"], 
                          silentReload: () {},
                        ),
                      ),
                      SizedBox(height: 120,),
                    ],
                  ) :
                  Obx(() => 
                    songItem(
                      artist: c.albumContentData["list"][index]["artist"], 
                      duration: c.albumContentData["list"][index]["duration"], 
                      index: index, 
                      title: c.albumContentData["list"][index]["title"], 
                      isLoved: operations().isLoved(c.albumContentData["list"][index]["id"]), 
                      playSong: ()=>playFromAlbum(index), 
                      isPlaying: isPlaying(index), 
                      id: c.albumContentData["list"][index]["id"],
                      silentReload: () {},
                    )
                  );
                }
              ): Container(),
            )
          )
        ],
      ),
    );
  }
}