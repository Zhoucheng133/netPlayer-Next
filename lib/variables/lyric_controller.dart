import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class LyricController extends GetxController {

  final Controller c = Get.find();
  var controller=AutoScrollController().obs;

  void scrollLyric(){
    if(!c.windowFocus.value){
      return;
    }
    if(c.lyricLine.value==0){
      controller.value.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      return;
    }
    controller.value.scrollToIndex(c.lyricLine.value-1, preferPosition: AutoScrollPosition.middle);
  }

}