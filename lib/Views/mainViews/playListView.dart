// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flash/flash.dart';
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

  // 刷新
  Future<void> reload() async {
    await getPlayList();
    if(c.playInfo["playFrom"]=="歌单" && c.playInfo["listId"]==c.nowPage["id"]){
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
  TextEditingController searchInput=TextEditingController();
  

  Future<void> getPlayList() async {
    if(c.nowPage["name"]=="歌单" && c.nowPage["id"]!.isNotEmpty){
      var resp=await playListRequest(c.nowPage["id"]!);
      try {
        setState(() {
          list=resp["entry"];
          subtitle="合计${resp["entry"].length}首歌";
        });
      } catch (_) {
        setState(() {
          list=[];
          subtitle="合计0首歌";
        });
      }
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

  List filterBySearch(){
    return list.where((item) => item["title"]!.toLowerCase().contains(searchInput.text.toLowerCase())).toList();
  }

  void playFromSearch(index){
    operations().playSong("歌单", c.nowPage["id"]!, list.indexWhere((item) => item["id"]==filterBySearch()[index]["id"]), list);
  }

  final ScrollController searchController=ScrollController();

  Future<void> silentReload() async {
    await getPlayList();
    reCalIndex();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => 
            titleBox(title: c.selectedListName.value, subtitle: subtitle, controller: searchInput, reloadList: () => reload(), scrollToIndex: ()=>scrollToIndex(), searchType: (value) {  },),
          ),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: onSearch ? ListView.builder(
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
            ) : ListView.builder(
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
                        Obx(() => songItem(
                          artist: list[index]["artist"], 
                          duration: list[index]["duration"], 
                          index: index, title: list[index]["title"], 
                          isLoved: operations().isLoved(list[index]["id"]), 
                          playSong: ()=>playSongFromPlaylist(index), 
                          isPlaying: isPlaying(index), 
                          listId: c.nowPage["id"],
                          id: list[index]["id"],
                          silentReload: ()=>silentReload(),
                        ),),
                        SizedBox(height: 120,),
                      ],
                    ):
                    Obx(() => songItem(
                      artist: list[index]["artist"], 
                      duration: list[index]["duration"], 
                      index: index, 
                      title: list[index]["title"], 
                      isLoved: operations().isLoved(list[index]["id"]), 
                      playSong: ()=>playSongFromPlaylist(index), 
                      isPlaying: isPlaying(index), 
                      listId: c.nowPage["id"],
                      id: list[index]["id"],
                      silentReload: ()=>silentReload()
                    ),),
                );
              }
            )
          )
        ],
      ),
    );
  }
}