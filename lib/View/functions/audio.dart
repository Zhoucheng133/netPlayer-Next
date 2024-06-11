// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, invalid_use_of_protected_member, prefer_const_constructors


import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/variables/variables.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = Player();
  var playURL="";

  audioHandler(){
    player.stream.position.listen((position) {
      c.playProgress.value=position.inMilliseconds;
    });
    player.stream.completed.listen((state) {
      if(state){
        skipToNext();
      }
    });
  }

  // 播放
  @override
  Future<void> play() async {
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}";
    if(url!=playURL){
      final media=Media(url);
      await player.open(media);
    }
    player.play();
    playURL=url;
  }

  // 暂停
  @override
  Future<void> pause() async {
    player.pause();
  }

  // 停止播放
  @override
  Future<void> stop() async {
    
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    player.seek(position);
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
    var tmpList=c.nowPlay.value;
    tmpList['index']=preHandler(c.nowPlay.value['index'], c.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    c.nowPlay.value=tmpList;
    c.nowPlay.refresh();
    play();
  }

  int nextHandler(int index, int length){
    if(index==length-1){
      return 0;
    }
    return index+1;
  }

  // 下一首
  @override
  Future<void> skipToNext() async {
    Map<String, dynamic> tmpList=c.nowPlay.value;
    tmpList['index']=nextHandler(c.nowPlay.value['index'], c.nowPlay.value['list'].length);
    tmpList['id']=tmpList['list'][tmpList['index']]['id'];
    tmpList['title']=tmpList['list'][tmpList['index']]['title'];
    tmpList['artist']=tmpList['list'][tmpList['index']]['artist'];
    tmpList['duration']=tmpList['list'][tmpList['index']]['duration'];
    c.nowPlay.value=tmpList;
    c.nowPlay.refresh();
    play();
  }
}