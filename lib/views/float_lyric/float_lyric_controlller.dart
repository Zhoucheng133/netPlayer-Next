import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FloatLyricControlller extends GetxController {

  WindowController? floatLyricController;

  final Controller controller= Get.find();

  Future<void> initLyricWindow() async {
    floatLyricController=await WindowController.create(
      const WindowConfiguration(
        hiddenAtLaunch: true,
        arguments: 'lyric',
      ),
    );
    final prefs=await SharedPreferences.getInstance();
    controller.showFloatLyric.value=prefs.getBool("showFloatLyric") ?? false;
    if(controller.showFloatLyric.value){
      floatLyricController?.show();
    }
  }

  void toggleLyricWindow(){
    if(floatLyricController==null){
      initLyricWindow();
    }
    if(controller.showFloatLyric.value){
      controller.showFloatLyric.value=false;
      floatLyricController?.hide();
    }else{
      controller.showFloatLyric.value=true;
      floatLyricController?.show();
    }
  }
}