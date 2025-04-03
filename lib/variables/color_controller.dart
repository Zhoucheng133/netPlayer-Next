import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Color tmpColor=baseColor.value;
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('theme'.tr),
        content: SizedBox(
          width: 400,
          height: 400,
          child: ColorPicker(
            pickerTypeLabels: {
              ColorPickerType.wheel: 'wheel'.tr,
              ColorPickerType.primary: 'primary'.tr
            },
            pickersEnabled: const {
              ColorPickerType.both: false,
              ColorPickerType.primary: true,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: false,
              ColorPickerType.customSecondary: false,
              ColorPickerType.wheel: true,
            },
            color: baseColor.value,
            onColorChanged: (Color color){
              baseColor.value=color;
            }
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              baseColor.value=tmpColor;
              Navigator.pop(context);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs=await SharedPreferences.getInstance();
              prefs.setInt('theme', baseColor.value.value);
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