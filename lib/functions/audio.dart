// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, invalid_use_of_protected_member, prefer_const_constructors

import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/functions/operations.dart';

import '../paras/paras.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = Player();
  
  var playUrl="";

  audioHandler(){

    player.stream.position.listen((position) {
      c.updatePlayProgress(position.inMilliseconds);
      // print(c.nowDuration);
    });
    player.stream.completed	.listen((state) {
      // if(state.processingState == ProcessingState.completed) {
      //   skipToNext();
      // }
      if(state){
        skipToNext();
      }
    });
  }

  MediaItem item=MediaItem(id: "", title: "");

  // 设置播放Info
  Future<void> setInfo(bool isPlay) async {
    item=MediaItem(
      id: c.playInfo["id"],
      album: c.playInfo["album"],
      title: c.playInfo["title"],
      artist: c.playInfo["artist"],
      artUri: Uri.parse("${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}"),
    );
    mediaItem.add(item);

    playbackState.add(playbackState.value.copyWith(
      playing: isPlay,
      controls: [
        MediaControl.skipToPrevious,
        isPlay ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
    ));
  }

  // 播放
  @override
  Future<void> play() async {
    if(c.playInfo["id"]==null){
      return;
    }
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}";

    if(playUrl!=url){
      // player.setUrl(url);
      final playURL=Media(url);
      await player.open(playURL);
    }
    player.play();
    playUrl=url;
    c.updateIsPlay(true);
    setInfo(true);
  }

  // 暂停
  @override
  Future<void> pause() async {
    if(c.playInfo["id"]==null){
      return;
    }
    await player.pause();
    c.updateIsPlay(false);
    setInfo(false);
  }

  // 停止播放
  @override
  Future<void> stop() async {
    if(c.playInfo["id"]==null){
      return;
    }
    await player.stop();
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    if(c.playInfo["id"]==null){
      return;
    }
    c.updateIsPlay(false);
    await player.seek(position);
    await play();
    setInfo(true);
  }

  // 上一首
  @override
  Future<void> skipToPrevious() async {
    if(c.playInfo.isEmpty){
      return;
    }
    
    if(c.fullRandomPlay.value){
      operations().playRandomSong();
      play();
      return;
    }

    if(c.playMode.value=="顺序播放" || c.playMode.value=="随机播放"){
      var playInfo={};
      if(c.playInfo["index"]==0){
        playInfo={
          "playFrom": c.playInfo["playFrom"],
          "id": c.playInfo["list"][c.playInfo["list"].length-1]["id"],
          "title": c.playInfo["list"][c.playInfo["list"].length-1]["title"],
          "artist": c.playInfo["list"][c.playInfo["list"].length-1]["artist"],
          "duration": c.playInfo["list"][c.playInfo["list"].length-1]["duration"],
          "album": c.playInfo["list"][c.playInfo["list"].length-1]["album"],
          "listId": c.playInfo["listId"],
          "index": c.playInfo["list"].length-1,
          "list": c.playInfo["list"],
        };
      }else{
        var newIndex=c.playInfo["index"]-1;
        playInfo={
          "playFrom": c.playInfo["playFrom"],
          "id": c.playInfo["list"][newIndex]["id"],
          "title": c.playInfo["list"][newIndex]["title"],
          "artist": c.playInfo["list"][newIndex]["artist"],
          "duration": c.playInfo["list"][newIndex]["duration"],
          "album": c.playInfo["list"][newIndex]["album"],
          "listId": c.playInfo["listId"],
          "index": newIndex,
          "list": c.playInfo["list"],
        };
      }
      c.updatePlayInfo(playInfo);
      play();
    }else{
      playUrl="";
      play();
    }
    setInfo(true);
  }

  // 下一首
  @override
  Future<void> skipToNext() async {
    if(c.playInfo.isEmpty){
      return;
    }

    if(c.fullRandomPlay.value){
      operations().playRandomSong();
      play();
      return;
    }
    
    switch (c.playMode.value){
      case "顺序播放": {
        var playInfo={};
        if(c.playInfo["index"]==c.playInfo["list"].length-1){
          playInfo={
            "playFrom": c.playInfo["playFrom"],
            "id": c.playInfo["list"][0]["id"],
            "title": c.playInfo["list"][0]["title"],
            "artist": c.playInfo["list"][0]["artist"],
            "duration": c.playInfo["list"][0]["duration"],
            "album": c.playInfo["list"][0]["album"],
            "listId": c.playInfo["listId"],
            "index": 0,
            "list": c.playInfo["list"],
          };
        }else{
          var newIndex=c.playInfo["index"]+1;
          playInfo={
            "playFrom": c.playInfo["playFrom"],
            "id": c.playInfo["list"][newIndex]["id"],
            "title": c.playInfo["list"][newIndex]["title"],
            "artist": c.playInfo["list"][newIndex]["artist"],
            "duration": c.playInfo["list"][newIndex]["duration"],
            "album": c.playInfo["list"][newIndex]["album"],
            "listId": c.playInfo["listId"],
            "index": newIndex,
            "list": c.playInfo["list"],
          };
        }
        c.updatePlayInfo(playInfo);
        play();
      }
      break;
      case "随机播放": {
        final random = Random();
        var newIndex=random.nextInt(c.playInfo["list"].length);
        var playInfo={
          "playFrom": c.playInfo["playFrom"],
          "id": c.playInfo["list"][newIndex]["id"],
          "title": c.playInfo["list"][newIndex]["title"],
          "artist": c.playInfo["list"][newIndex]["artist"],
          "duration": c.playInfo["list"][newIndex]["duration"],
          "album": c.playInfo["list"][newIndex]["album"],
          "listId": c.playInfo["listId"],
          "index": newIndex,
          "list": c.playInfo["list"],
        };
        c.updatePlayInfo(playInfo);
        play();
      }
      break;
      case "单曲循环": {
        playUrl="";
        play();
      }
      break;
    }
    setInfo(true);
  }
}