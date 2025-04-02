import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {

  // final testColor=const Color.fromARGB(255, 120, 135, 232);

  Rx<Color> baseColor = Colors.blue.obs;
  Rx<Color> white=Colors.white.obs;
  Rx<Color> black=Colors.black.obs;
  RxBool darkMode = false.obs;

  ColorController(Color? basec, bool? dark){
    baseColor.value=basec??Colors.blue;
    darkMode.value=dark??false;
  }

  Color color1(){
    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.986).toColor();
  }

  Color color2(){
    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.958).toColor();
  }

  Color color3(){
    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.935).toColor();
  }

  Color color4(){
    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.85).toColor();
  }

  Color color5(){
    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.7).toColor();
  }

  Color color6()=>baseColor.value;
}