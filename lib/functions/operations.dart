// ignore_for_file: camel_case_types, use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/request.dart';

import '../paras/paras.dart';

class operations{
  final Controller c = Get.put(Controller());

  Future<void> getAllSongs(BuildContext context) async {
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

  Future<void> getPlayLists() async {
    c.updateAllPlayList(await allListsRequest());
  }

  Future<void> getLovedSongs() async {
    c.updateLovedSongs(await lovedSongRequest());
  }

  bool isLoved(String id){
    for (var val in c.lovedSongs) {
      if(val["id"]==id){
        return true;
      }
    }
    return false;
  }

  String timeConvert(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  void playSong(String playFrom, String listId, int index, List list){
    var playInfo={
      "playFrom": playFrom,
      "id": list[index]["id"],
      "title": list[index]["title"],
      "artist": list[index]["artist"],
      "duration": list[index]["duration"],
      "listId": listId,
      "index": index,
      "list": list,
    };
    c.updatePlayInfo(playInfo);
    c.handler.play();
  }

  void toggleSong(){
    // TODO 暂停/播放
  }

  void nextSong(){
    // TODO 下一首
  }

  void preSong(){
    // TODO 上一首
  }
}