// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/functions/operations.dart';

import '../../paras/paras.dart';
import '../components/listItems.dart';
import '../components/titleBar.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

  final Controller c = Get.put(Controller());
  TextEditingController searchInput=TextEditingController();

  @override
  void initState() {
    super.initState();

    searchInput.addListener(() {
      search(searchInput.text);
    });
  }

  var songList=[];
  var artistList=[];
  var albumList=[];

  Future<void> search(String val) async {
    if(val==""){
      setState(() {
        songList=[];
        artistList=[];
        albumList=[];
      });
    }
    var data=await operations().searchHandler(val);
    setState(() {
      songList=data["songs"];
      artistList=data["artists"];
      albumList=data["albums"];
    });
  }

  void reload(){/** 空函数 */}

  var type="歌曲";

  ScrollController songController=ScrollController();
  ScrollController albumController=ScrollController();
  ScrollController artistController=ScrollController();

  void playFromSearch(int index){
    operations().playSong("搜索", searchInput.text, index, songList);
  }

  bool isPlaying(index){
    if(c.playInfo["playFrom"]!="搜索"){
      return false;
    }else{
      if(c.playInfo["index"]==index && c.playInfo["listId"]==searchInput.text){
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
          titleBox(title: "搜索", subtitle: "", controller: searchInput, reloadList: () => reload(), searchType: (value) { setState(() { type=value; }); },),
          SizedBox(height: 10,),
          Expanded(
            child: Column(
              children: [
                type=="歌曲" ? songsHeader() :
                type=="专辑" ? albumHeader() :
                artistsHeader(),
                Expanded(
                  child: type=="歌曲" ? ListView.builder(
                    controller: songController,
                    itemCount: songList.length,
                    itemBuilder: (BuildContext context, int index){
                      return index==songList.length-1 ? 
                          Column(
                            children: [
                              Obx(() => songItem(
                                artist: songList[index]["artist"], 
                                duration: songList[index]["duration"], 
                                index: index, 
                                title: songList[index]["title"], 
                                isLoved: operations().isLoved(songList[index]["id"]), 
                                playSong: ()=>playFromSearch(index), 
                                isPlaying: isPlaying(index), 
                                id: songList[index]["id"],
                                silentReload: ()=>{},
                              ),),
                              SizedBox(height: 120,),
                            ],
                          ):
                          Obx(() => 
                            songItem(
                              artist: songList[index]["artist"], 
                              duration: songList[index]["duration"], 
                              index: index, 
                              title: songList[index]["title"], 
                              isLoved: operations().isLoved(songList[index]["id"]), 
                              playSong: ()=>playFromSearch(index), 
                              isPlaying: isPlaying(index), 
                              id: songList[index]["id"],
                              silentReload: ()=>{},
                            )
                          );
                    }
                  ) : type=="艺人" ? ListView.builder(
                    controller: artistController,
                    itemCount: artistList.length,
                    itemBuilder: (BuildContext context, int index){
                      return index==artistList.length-1 ? 
                      Column(
                        children: [
                          artistItem(index: index, id: artistList[index]["id"], name: artistList[index]["name"], count: artistList[index]["albumCount"]),
                          SizedBox(height: 120,),
                        ],
                      ):
                      artistItem(index: index, id: artistList[index]["id"], name:artistList[index]["name"], count: artistList[index]["albumCount"]);
                    }
                  ) : ListView.builder(
                    controller: albumController,
                    itemCount: albumList.length,
                    itemBuilder: (BuildContext context, int index){
                      return index==albumList.length-1 ? 
                          Column(
                            children: [
                              albumItem(index: index, title: albumList[index]["title"], count: albumList[index]["songCount"], id: albumList[index]["id"], artist: albumList[index]["artist"],),
                              SizedBox(height: 120,),
                            ],
                          ):
                          albumItem(index: index, title: albumList[index]["title"], count: albumList[index]["songCount"], id: albumList[index]["id"], artist: albumList[index]["artist"]);
                    }
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}