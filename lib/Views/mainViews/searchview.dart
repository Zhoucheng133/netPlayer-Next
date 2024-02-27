// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/functions/operations.dart';

import '../components/listItems.dart';
import '../components/titleBar.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

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
    // TODO 从搜索界面播放歌曲
  }

  bool isPlaying(index){
    // 判定是否播放
    return false;
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
                              ),
                              SizedBox(height: 120,),
                            ],
                          ):
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
                  ) : Container()
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}