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

  var title="";
  var list=[];

  Future<void> getData() async {
    if(c.nowPage["id"]=="" || c.nowPage["name"]!="专辑"){
      return;
    }
    var data={};
    if(c.nowPage["id"]!=null){
      data=await operations().getAlbumData(c.nowPage["id"]??"");
    }
    setState(() {
      title=data["title"];
      list=data["list"];
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  final ScrollController controller=ScrollController();

  void playFromAlbum(int index){
    operations().playSong("专辑", c.nowPage["id"]??"", index, list);
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
          titleBoxWithBack(title: "专辑: $title", subtitle: "含有歌曲${list.length}首",),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return index==list.length-1 ? Column(
                  children: [
                    Obx(() => 
                      songItem(
                        artist: list[index]["artist"], 
                        duration: list[index]["duration"], 
                        index: index, 
                        title: list[index]["title"], 
                        isLoved: operations().isLoved(list[index]["id"]), 
                        playSong: ()=>playFromAlbum(index), 
                        isPlaying: isPlaying(index), 
                        id: list[index]["id"], 
                        silentReload: () {},
                      ),
                    ),
                    SizedBox(height: 120,),
                  ],
                ) :
                Obx(() => 
                  songItem(
                    artist: list[index]["artist"], 
                    duration: list[index]["duration"], 
                    index: index, 
                    title: list[index]["title"], 
                    isLoved: operations().isLoved(list[index]["id"]), 
                    playSong: ()=>playFromAlbum(index), 
                    isPlaying: isPlaying(index), 
                    id: list[index]["id"],
                    silentReload: () {},
                  )
                );
              }
            ),
          )
        ],
      ),
    );
  }
}