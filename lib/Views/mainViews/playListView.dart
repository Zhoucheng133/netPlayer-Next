// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/request.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../functions/operations.dart';
import '../../paras/paras.dart';
import '../components/listItems.dart';
import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {

  final Controller c = Get.put(Controller());

  var list=[];
  var subtitle="";

    void search(value){
    // TODO 搜索歌曲
  }

  void reCalIndex(){
    int index = list.indexWhere((element) => element["id"] == c.playInfo["id"]);
    if(index==-1){
      operations().stop();
      c.updatePlayInfo({});
      return;
    }
    var tmpPlayInfo=c.playInfo.value;
    tmpPlayInfo["index"]=index;
    tmpPlayInfo["list"]=list;
    c.updatePlayInfo(tmpPlayInfo);
  }

  Future<void> reload() async {
    await getPlayList();
    if(c.playInfo["playFrom"]=="歌单" && c.playInfo["listId"]==c.nowPage["id"]){
      reCalIndex();
    }
  }
  TextEditingController searchInput=TextEditingController();
  

  Future<void> getPlayList() async {
    if(c.nowPage["name"]=="歌单" && c.nowPage["id"]!.isNotEmpty){
      var resp=await playListRequest(c.nowPage["id"]!);
      try {
        setState(() {
          list=resp["entry"];
          subtitle="合计${resp["entry"].length}首歌";
        });
      } catch (_) {}
    }
  }

  @override
  void initState() {
    super.initState();

    ever(c.nowPage, (callback){
      getPlayList();
    });

    searchInput.addListener(() {
      search(searchInput.text);
    });
  }

  var controller=AutoScrollController();

  void playSongFromPlaylist(index){
    operations().playSong("歌单", c.nowPage["id"]!, index, list);
  }

  bool isPlaying(index){
    if(c.playInfo["playFrom"]!="歌单"){
      return false;
    }else{
      if(c.playInfo["index"]==index && c.playInfo["listId"]==c.nowPage["id"]){
        return true;
      }
      return false;
    }
  }

  void scrollToIndex(){
    if(c.playInfo["index"]!=null && c.playInfo["playFrom"]=="歌单" && c.playInfo["listId"]==c.nowPage["id"]){
      controller.scrollToIndex(c.playInfo["index"], preferPosition: AutoScrollPosition.begin);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => 
            titleBox(title: c.selectedListName.value, subtitle: subtitle, controller: searchInput, reloadList: () => reload(), scrollToIndex: ()=>scrollToIndex(),),
          ),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: ListView.builder(
              controller: controller,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return AutoScrollTag(
                  key: ValueKey(index), 
                  controller: controller, 
                  index: index,
                  child: index==list.length-1 ? 
                    Column(
                      children: [
                        Obx(() => songItem(artist: list[index]["artist"], duration: list[index]["duration"], index: index, title: list[index]["title"], isLoved: operations().isLoved(list[index]["id"]), playSong: ()=>playSongFromPlaylist(index), isPlaying: isPlaying(index),),),
                        SizedBox(height: 120,),
                      ],
                    ):
                    Obx(() => songItem(artist: list[index]["artist"], duration: list[index]["duration"], index: index, title: list[index]["title"], isLoved: operations().isLoved(list[index]["id"]), playSong: ()=>playSongFromPlaylist(index), isPlaying: isPlaying(index),),),
                );
              }
            )
          )
        ],
      ),
    );
  }
}