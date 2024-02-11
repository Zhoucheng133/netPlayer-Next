// ignore_for_file: camel_case_types

import 'package:audio_service/audio_service.dart';

class audioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {

  @override
  Future<void> play() async {
    print("play!");
  }
  @override
  Future<void> pause() async {

  }
  @override
  Future<void> stop() async {

  }
  @override
  Future<void> seek(Duration position) async {

  }
}