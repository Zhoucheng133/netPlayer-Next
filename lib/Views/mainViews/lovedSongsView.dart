// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flash/flash.dart';
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

  bool onSearch=false;

  void search(value){
    if(value==""){
      setState(() {
        onSearch=false;
      });
    }else{
      setState(() {
        onSearch=true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    searchInput.addListener(() {
      search(searchInput.text);
    });
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

  // 刷新
  Future<void> reload() async {
    await operations().getLovedSongs();
    if(c.playInfo["playFrom"]=="喜欢的歌曲"){
      reCalIndex();
    }
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
          Icons.done,
        ),
        controller: controller, 
        content: Text(
          "刷新完成",
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

  List filterBySearch(){
    return c.lovedSongs.where((item) => item["title"]!.toLowerCase().contains(searchInput.text.toLowerCase())).toList();
  }

  void playFromSearch(index){
    operations().playSong("喜欢的歌曲", "", c.lovedSongs.indexWhere((item) => item["id"]==filterBySearch()[index]["id"]), c.lovedSongs);
  }

  final ScrollController searchController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => titleBox(title: "喜欢的歌曲", subtitle: "合计${c.lovedSongs.length}首歌", controller: searchInput, reloadList: () => reload(), scrollToIndex: ()=>scrollToIndex(),)),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: onSearch ? 
            Obx(() => 
              ListView.builder(
                controller: searchController,
                itemCount: filterBySearch().length,
                itemBuilder: (BuildContext context, int index){
                  return index==filterBySearch().length-1 ? Column(
                    children: [
                      songItem(
                        artist: filterBySearch()[index]["artist"], 
                        duration: filterBySearch()[index]["duration"], 
                        index: index, 
                        title: filterBySearch()[index]["title"], 
                        isLoved: operations().isLoved(filterBySearch()[index]["id"]), 
                        playSong: ()=>playFromSearch(index), 
                        isPlaying: false, 
                        id: filterBySearch()[index]["id"],
                      ),
                      SizedBox(height: 120,),
                    ],
                  ) :
                  songItem(
                    artist: filterBySearch()[index]["artist"], 
                    duration: filterBySearch()[index]["duration"], 
                    index: index, 
                    title: filterBySearch()[index]["title"], 
                    isLoved: operations().isLoved(filterBySearch()[index]["id"]), 
                    playSong: ()=>playFromSearch(index), 
                    isPlaying: false, 
                    id: filterBySearch()[index]["id"],
                  );
                }
              )
            ) : Obx(() => 
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
                          Obx(() => songItem(
                            artist: c.lovedSongs[index]["artist"], 
                            duration: c.lovedSongs[index]["duration"], 
                            index: index, title: c.lovedSongs[index]["title"], 
                            isLoved: operations().isLoved(c.lovedSongs[index]["id"]), 
                            playSong: ()=>playSongFromLovedSongs(index), 
                            isPlaying: isPlaying(index),
                            id: c.lovedSongs[index]["id"],
                          ),),
                          SizedBox(height: 120,),
                        ],
                      ):
                      Obx(() => songItem(
                        artist: c.lovedSongs[index]["artist"], 
                        duration: c.lovedSongs[index]["duration"], 
                        index: index, 
                        title: c.lovedSongs[index]["title"], 
                        isLoved: operations().isLoved(c.lovedSongs[index]["id"]), 
                        playSong: ()=>playSongFromLovedSongs(index), 
                        isPlaying: isPlaying(index), 
                        id: c.lovedSongs[index]["id"],
                      ),),
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