// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, invalid_use_of_protected_member, prefer_const_constructors


import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:smtc_windows/smtc_windows.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = Player();
  var playURL="";
  bool skipHandler=false;
  MediaItem item=MediaItem(id: "", title: "");
  final operations=Operations();


  audioHandler(){
    player.stream.position.listen((position) {
      var data=position.inMilliseconds;
      if(!c.onslide.value){
        c.playProgress.value=data;
      }
      if(c.lyric.isNotEmpty && c.lyric.length!=1){
        for (var i = 0; i < c.lyric.length; i++) {
          if(i==c.lyric.length-1){
            c.lyricLine.value=c.lyric.length;
            break;
          }else if(i==0 && data<c.lyric[i]['time']){
            // updateLyricLine(0);
            c.lyricLine.value=0;
            break;
          }else if(data>=c.lyric[i]['time'] && data<c.lyric[i+1]['time']){
            // updateLyricLine(i+1);
            c.lyricLine.value=i+1;
            break;
          }
        }
      }else if(c.lyric.length==1){
        // updateLyricLine(0);
        c.lyricLine.value=0;
      }
    });
    player.stream.completed.listen((state) {
      if(state){
        skipToNext();
      }
    });
  }

  void setMedia(bool isPlay){
    if(Platform.isWindows){
      c.smtc.updateMetadata(
        MusicMetadata(
          title: c.nowPlay["title"]??'',
          album: c.nowPlay["album"]??'',
          albumArtist: c.nowPlay["artist"]??'',
          artist: c.nowPlay["artist"]??'',
          thumbnail: "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}"
        ),
      );
      c.smtc.setPlaybackStatus(isPlay ? PlaybackStatus.Playing : PlaybackStatus.Paused);
    }
    item=MediaItem(
      id: c.nowPlay["id"],
      title: c.nowPlay["title"],
      artist: c.nowPlay["artist"],
      artUri: Uri.parse("${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}"),
      album: c.nowPlay["album"],
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
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}";
    if(url!=playURL || skipHandler){
      final media=Media(url);
      await player.open(media);
    }
    player.play();
    if(skipHandler){
      skipHandler=false;
    }
    playURL=url;
    setMedia(true);
  }

  // 暂停
  @override
  Future<void> pause() async {
    player.pause();
    setMedia(false);
  }

  // 停止播放
  @override
  Future<void> stop() async {
    player.stop();
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    c.onslide.value=true;
    await player.pause();
    await player.seek(position);
    setMedia(true);
    c.onslide.value=false;
  }

  int preHandler(int index, int length){
    if(index==0){
      return length-1;
    }
    return index-1;
  }

  // 上一首
  @override
  Future<void> skipToPrevious() async {
    if(c.fullRandom.value){
      operations.fullRandomPlay();
      return;
    }
    var tmpList=c.nowPlay.value;
    tmpList['index']=preHandler(c.nowPlay.value['index'], c.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    tmpList['album']=tmpList['list'][tmpList['index']]['album'];
    // c.nowPlay.value=tmpList;
    // c.updateNowPlay(tmpList);
    c.nowPlay.value=tmpList;
    c.nowPlay.refresh();
    skipHandler=true;
    play();
    setMedia(true);
  }

  int nextHandler(int index, int length){
    if(c.playMode.value=='list'){
      if(index==length-1){
        return 0;
      }
      return index+1;
    }else if(c.playMode.value=='random'){
      if(length==1){
        return 0;
      }
      Random random =Random();
      return random.nextInt(length-1);
    }else{
      return index;
    }
    
  }

  // 下一首
  @override
  Future<void> skipToNext() async {
    if(c.fullRandom.value){
      operations.fullRandomPlay();
      return;
    }
    Map<String, dynamic> tmpList=c.nowPlay.value;
    tmpList['index']=nextHandler(c.nowPlay.value['index'], c.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    tmpList['album']=tmpList['list'][tmpList['index']]['album'];
    // c.updateNowPlay(tmpList);
    c.nowPlay.value=tmpList;
    c.nowPlay.refresh();
    skipHandler=true;
    play();
    setMedia(true);
  }

  Future<void> volumeSet(val) async {
    await player.setVolume(val.toDouble());
  }
}