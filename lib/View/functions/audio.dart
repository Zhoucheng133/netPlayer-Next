// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, invalid_use_of_protected_member, prefer_const_constructors


import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  final Controller c = Get.put(Controller());
  final player = AudioPlayer();

  // 播放
  @override
  Future<void> play() async {
    
  }

  // 暂停
  @override
  Future<void> pause() async {
    
  }

  // 停止播放
  @override
  Future<void> stop() async {
    
  }

  // 跳转
  @override
  Future<void> seek(Duration position) async {
    
  }

  // 上一首
  @override
  Future<void> skipToPrevious() async {
    
  }

  // 下一首
  @override
  Future<void> skipToNext() async {
    
  }
}