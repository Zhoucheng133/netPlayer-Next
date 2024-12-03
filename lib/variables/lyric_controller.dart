import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class LyricController extends GetxController {

  final Controller c = Get.put(Controller());
  var controller=AutoScrollController().obs;

  void scrollLyric(){
    if(c.lyricLine.value==0){
      return;
    }
    controller.value.scrollToIndex(c.lyricLine.value-1, preferPosition: AutoScrollPosition.middle);
  }

}