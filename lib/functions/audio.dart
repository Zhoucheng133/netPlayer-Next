// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../paras/paras.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  @override
  Future<void> play() async {
    if(c.playInfo["id"]==null){
      return;
    }
    var url="${c.userInfo["url"]}/rest/stream?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}";
    player.setUrl(url);
    player.play();
  }
  @override
  Future<void> pause() async {
    player.pause();
  }
  @override
  Future<void> stop() async {
    player.stop();
  }
  @override
  Future<void> seek(Duration position) async {

  }
}