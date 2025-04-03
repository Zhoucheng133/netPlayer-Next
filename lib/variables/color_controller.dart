import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorController extends GetxController {

  Rx<Color> baseColor = const Color.fromARGB(255, 33, 150, 243).obs;
  Rx<Color> white=Colors.white.obs;
  Rx<Color> black=Colors.black.obs;
  RxBool darkMode = false.obs;

  ColorController(Color? basec, bool? dark){
    baseColor.value=basec??const Color.fromARGB(255, 33, 150, 243);
    darkMode.value=dark??false;
  }

  void colorPickerPanel(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('theme'.tr),
        content: SizedBox(
          width: 400,
          height: 400,
          child: ColorPicker(
            color: baseColor.value,
            onColorChanged: (Color color){
              baseColor.value=color;
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      )
    );
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