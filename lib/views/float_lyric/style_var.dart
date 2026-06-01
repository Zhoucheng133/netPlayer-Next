import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageType{
  String name;
  Locale locale;

  LanguageType(this.name, this.locale);
}

List<LanguageType> get supportedLocales => [
  LanguageType("English", const Locale("en", "US")),
  LanguageType("简体中文", const Locale("zh", "CN")),
  LanguageType("繁體中文", const Locale("zh", "TW")),
];


class StyleVar extends GetxController{
  RxInt opacity=255.obs;
  RxBool showShadow=false.obs;
  RxInt fontSize=20.obs;
  RxBool alwaysOnTop=true.obs;
  RxDouble positionX=RxDouble(0.0);
  RxDouble positionY=RxDouble(0.0);

  late SharedPreferences prefs;

  Rx<LanguageType> lang=Rx(supportedLocales[0]);

  Future<void> initLang() async {
    prefs=await SharedPreferences.getInstance();

    int? langIndex=prefs.getInt("langIndex");

    if(langIndex==null){
      final deviceLocale=PlatformDispatcher.instance.locale;
      final local=Locale(deviceLocale.languageCode, deviceLocale.countryCode);
      int index=supportedLocales.indexWhere((element) => element.locale==local);
      if(index!=-1){
        lang.value=supportedLocales[index];
        lang.refresh();
      }
    }else{
      lang.value=supportedLocales[langIndex];
    }
  }

  initPrefs() async {
    final prefs=await SharedPreferences.getInstance();
    alwaysOnTop.value=prefs.getBool("alwaysOnTop") ?? true;
    // if(s.alwaysOnTop.value){
    //   await windowManager.setAlwaysOnTop(true);
    // }
    showShadow.value=prefs.getBool("showShadow") ?? false;
    // if(!s.showShadow.value){
    //   await windowManager.setHasShadow(false);
    // }
    fontSize.value=prefs.getInt("fontSize") ?? 20;

    positionX.value=prefs.getDouble("positionX") ?? 0;
    positionY.value=prefs.getDouble("positionY") ?? 0;
    // if(positionX!=0&&positionY!=0){
    //   await windowManager.setPosition(Offset(positionX, positionY));
    // }else{
    //   await windowManager.center();
    // }
    opacity.value=prefs.getInt("opacity") ?? 50;
  }
}