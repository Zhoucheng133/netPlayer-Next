// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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

  // 重新计算Index的值
  void reCalIndex(){
    int index = c.lovedSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
    if(index==-1){
      operations().stop();
      c.updatePlayInfo({});
      return;
    }
    var tmpPlayInfo=c.playInfo.value;
    tmpPlayInfo["index"]=index;
    tmpPlayInfo["list"]=c.lovedSongs.value;
    c.updatePlayInfo(tmpPlayInfo);
  }

  Future<void> reload() async {
    await operations().getLovedSongs();
    if(c.playInfo["playFrom"]=="喜欢的歌曲"){
      reCalIndex();
    }
  }

  void playSongFromLovedSongs(int index){
    operations().playSong("喜欢的歌曲", "", index, c.lovedSongs);
  }

  void scrollToIndex(){
    if(c.playInfo["index"]!=null && c.playInfo["playFrom"]=="喜欢的歌曲"){
      controller.scrollToIndex(c.playInfo["index"], preferPosition: AutoScrollPosition.begin);
    }
  }

  TextEditingController searchInput=TextEditingController();

  var controller=AutoScrollController();

  bool isPlaying(index){
    if(c.playInfo["playFrom"]!="喜欢的歌曲"){
      return false;
    }else{
      if(c.playInfo["index"]==index){
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
          Obx(() => titleBox(searchController: search, title: "喜欢的歌曲", subtitle: "合计${c.lovedSongs.length}首歌", controller: searchInput, reloadList: () => reload(), scrollToIndex: ()=>scrollToIndex(),)),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.lovedSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return AutoScrollTag(
                    key: ValueKey(index), 
                    controller: controller, 
                    index: index,
                    child: index==c.lovedSongs.length-1 ? 
                      Column(
                        children: [
                          Obx(() => songItem(artist: c.lovedSongs[index]["artist"], duration: c.lovedSongs[index]["duration"], index: index, title: c.lovedSongs[index]["title"], isLoved: operations().isLoved(c.lovedSongs[index]["id"]), playSong: ()=>playSongFromLovedSongs(index), isPlaying: isPlaying(index),),),
                          SizedBox(height: 120,),
                        ],
                      ):
                      Obx(() => songItem(artist: c.lovedSongs[index]["artist"], duration: c.lovedSongs[index]["duration"], index: index, title: c.lovedSongs[index]["title"], isLoved: operations().isLoved(c.lovedSongs[index]["id"]), playSong: ()=>playSongFromLovedSongs(index), isPlaying: isPlaying(index),),),
                  );
                }
              )
            )
          )
        ],
      ),
    );
  }
}