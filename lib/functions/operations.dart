// ignore_for_file: camel_case_types, use_build_context_synchronously, prefer_const_constructors, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/request.dart';

import '../paras/paras.dart';

class operations{
  final Controller c = Get.put(Controller());

  Future<void> getAllSongs(BuildContext context) async {
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

  Future<void> getAlbums() async {
    c.updateAllAlbums(await albumsRequest());
  }

  Future<void> getArtist() async {
    c.updateAllArtists(await artistsRequest());
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
    if(c.isPlay.value){
      c.handler.pause();
    }else{
      c.handler.play();
    }
  }

  void stop(){
    c.handler.stop();
  }

  void pause(){
    c.handler.pause();
  }

  void nextSong(){
    c.handler.skipToNext();
  }

  void preSong(){
    c.handler.skipToPrevious();
  }

  void seek(Duration d){
    c.handler.seek(d);
  }

  Future<bool> love(String id) async {
    var val = await setLove(id);
    if(val){
      await getLovedSongs();
    }
    if(c.playInfo["playFrom"]=="喜欢的歌曲"){
      int index = c.lovedSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
      if(index==-1){
        operations().stop();
        c.updatePlayInfo({});
      }
      var tmpPlayInfo=c.playInfo.value;
      tmpPlayInfo["index"]=index;
      tmpPlayInfo["list"]=c.lovedSongs.value;
      c.updatePlayInfo(tmpPlayInfo);
    }
    return val;
  }

  Future<bool> delove(String id) async {
    var val = await setDelove(id);
    if(val){
      await getLovedSongs();
    }
    if(c.playInfo["playFrom"]=="喜欢的歌曲"){
      int index = c.lovedSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
      if(index==-1){
        operations().stop();
        c.updatePlayInfo({});
      }
      var tmpPlayInfo=c.playInfo.value;
      tmpPlayInfo["index"]=index;
      tmpPlayInfo["list"]=c.lovedSongs.value;
      c.updatePlayInfo(tmpPlayInfo);
    }
    return val;
  }

  Future<bool> addList(String title) async {
    var val = await newList(title);
    if(val){
      await getPlayLists();
    }
    return val;
  }

  Future<bool> delList(String id) async {
    var val=await delListRequest(id);
    if(val){
      await getPlayLists();
    }
    return val;
  }

  Future<bool> renameList(String id, String newName) async {
    var val =await reNameList(id, newName);
    if(val){
      await getPlayLists();
    }
    return val;
  }

  Future<bool> songAddList(String listId, String songId) async {
    var val=await addToList(listId, songId);
    return val;
  }

  Future<bool> delFromList(String listId, int index) async {
    var val=await delFromListRequest(listId, index);
    return val;
  }

  Future<Map> getAlbumData(String id) async {
    return await albumDataRequest(id);
  }

  Future<Map> getArtistData(String id) async {
    return await artistDataRequest(id);
  }

  Map getRandomSong(){
    
    return {};
  }
}