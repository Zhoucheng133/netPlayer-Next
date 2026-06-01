import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StyleVar extends GetxController{
  RxInt opacity=255.obs;
  RxBool showShadow=false.obs;
  RxInt fontSize=18.obs;
  RxBool alwaysOnTop=true.obs;
  RxDouble positionX=RxDouble(0.0);
  RxDouble positionY=RxDouble(0.0);

  initPrefs() async {
    final prefs=await SharedPreferences.getInstance();
    alwaysOnTop.value=prefs.getBool("alwaysOnTop")??true;
    // if(s.alwaysOnTop.value){
    //   await windowManager.setAlwaysOnTop(true);
    // }
    showShadow.value=prefs.getBool("showShadow")??false;
    // if(!s.showShadow.value){
    //   await windowManager.setHasShadow(false);
    // }
    fontSize.value=prefs.getInt("fontSize")??18;

    positionX.value=prefs.getDouble("positionX")??0;
    positionY.value=prefs.getDouble("positionY")??0;
    // if(positionX!=0&&positionY!=0){
    //   await windowManager.setPosition(Offset(positionX, positionY));
    // }else{
    //   await windowManager.center();
    // }
    opacity.value=prefs.getInt("opacity")??100;
  }
}