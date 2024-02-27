// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, invalid_use_of_protected_member

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/Views/components/titleBar.dart';
import 'package:net_player_next/functions/operations.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../functions/request.dart';
import '../../paras/paras.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key});

  @override
  State<allSongsView> createState() => _allSongsViewState();
}


class _allSongsViewState extends State<allSongsView> {

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

  // 重新计算Index的值
  void reCalIndex(){
    int index = c.allSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
    if(index==-1){
      operations().stop();
      c.updatePlayInfo({});
      return;
    }
    var tmpPlayInfo=c.playInfo.value;
    tmpPlayInfo["index"]=index;
    tmpPlayInfo["list"]=c.allSongs.value;
    c.updatePlayInfo(tmpPlayInfo);
  }

  // 刷新
  Future<void> reload() async {
    await operations().getAllSongs(context);
    if(c.playInfo["playFrom"]=="所有歌曲"){
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

  Future<void> loadList() async {
    if(c.allSongs.isNotEmpty){
      return;
    }
    var resp=await allSongsRequest();
    if(resp["status"]=="ok"){
      var tmpList=resp["randomSongs"]["song"];
      tmpList.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(a['created']);
        DateTime dateTimeB = DateTime.parse(b['created']);
        return dateTimeB.compareTo(dateTimeA);
      });
      c.updateAllSongs(tmpList);
    }else{
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("请求所有歌曲失败"),
            content: Text("请检查互联网连接"),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("好的"),
              )
            ],
          );
        }
      );
    }
  }

  @override
  void initState() {
    super.initState();

    operations().getAllSongs(context);
    searchInput.addListener(() {
      search(searchInput.text);
    });
  }

  TextEditingController searchInput=TextEditingController();

  var controller=AutoScrollController();

  void playSongFromAllSongs(int index){
    operations().playSong("所有歌曲", "", index, c.allSongs);
  }

  bool isPlaying(index){
    if(c.playInfo["playFrom"]!="所有歌曲"){
      return false;
    }else{
      if(c.playInfo["index"]==index){
        return true;
      }
      return false;
    }
  }

  void scrollToIndex(){
    if(c.playInfo["index"]!=null && c.playInfo["playFrom"]=="所有歌曲"){
      controller.scrollToIndex(c.playInfo["index"], preferPosition: AutoScrollPosition.begin);
    }
  }

  List filterBySearch(){
    return c.allSongs.where((item) => item["title"]!.toLowerCase().contains(searchInput.text.toLowerCase())).toList();
  }

  void playFromSearch(index){
    operations().playSong("所有歌曲", "", c.allSongs.indexWhere((item) => item["id"]==filterBySearch()[index]["id"]), c.allSongs);
  }
  
  final ScrollController searchController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => 
            titleBox(title: "所有歌曲", subtitle: "合计${c.allSongs.length}首歌", controller: searchInput, reloadList: () => reload(), scrollToIndex: () => scrollToIndex(), searchType: (value) {  },),
          ),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
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
                        silentReload: () {},
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
                    silentReload: () {},
                  );
                }
              )
            ) : Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.allSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return AutoScrollTag(
                    key: ValueKey(index), 
                    controller: controller, 
                    index: index,
                    child: index==c.allSongs.length-1 ? 
                      Column(
                        children: [
                          Obx(() => songItem(
                            artist: c.allSongs[index]["artist"], 
                            duration: c.allSongs[index]["duration"], 
                            index: index, 
                            title: c.allSongs[index]["title"], 
                            isLoved: operations().isLoved(c.allSongs[index]["id"]), 
                            playSong: ()=>playSongFromAllSongs(index), 
                            isPlaying: isPlaying(index), 
                            id: c.allSongs[index]["id"],
                            silentReload: () {},
                          ),),
                          SizedBox(height: 120,),
                        ],
                      ):
                      Obx(() => songItem(
                        artist: c.allSongs[index]["artist"], 
                        duration: c.allSongs[index]["duration"], 
                        index: index, 
                        title: c.allSongs[index]["title"], 
                        isLoved: operations().isLoved(c.allSongs[index]["id"]), 
                        playSong: ()=>playSongFromAllSongs(index), 
                        isPlaying: isPlaying(index), 
                        id: c.allSongs[index]["id"],
                        silentReload: () {},
                      ),),
                  );
                }
              )
            )
          ),
        ],
      ),
    );
  }
}