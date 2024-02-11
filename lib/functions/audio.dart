// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../paras/paras.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = AudioPlayer();
  
  var playUrl="";

  audioHandler(){
    // TODO 添加播放State
    player.positionStream.listen((position) {
      c.updatePlayProgress(position.inMilliseconds);
      // print(c.nowDuration);
    });
    player.playerStateStream.listen((state) {
      if(state.processingState == ProcessingState.completed) {
        print("complete");
        skipToNext();
      }
    });
  }

  @override
  Future<void> play() async {
    if(c.playInfo["id"]==null){
      return;
    }
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}";

    if(playUrl!=url){
      player.setUrl(url);
    }
    player.play();
    playUrl=url;
  }
  @override
  Future<void> pause() async {
    await player.pause();
  }
  @override
  Future<void> stop() async {
    await player.stop();
  }
  @override
  Future<void> seek(Duration position) async {
    await player.seek(position);
    await play();
  }
  @override
  Future<void> skipToNext()async{
    // TODO 下一首的操作
  }
}