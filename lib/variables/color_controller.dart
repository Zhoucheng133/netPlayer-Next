import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorController extends GetxController {

  Rx<Color> baseColor = const Color.fromARGB(255, 33, 150, 243).obs;
  Rx<Color> white=Colors.white.obs;
  Rx<Color> black=Colors.black.obs;
  RxBool darkMode = true.obs;
  RxBool autoDark=true.obs;

  ColorController(Color? basec, bool? dark, bool? auto){
    baseColor.value=basec??const Color.fromARGB(255, 33, 150, 243);
    darkMode.value=dark??false;
    autoDark.value=auto??true;
  }

  void autoDarkMode(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }

  void darkModePanel(BuildContext context){

    bool tmpDarkMode=darkMode.value;
    bool tmpAutoDark=autoDark.value;

    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('darkMode'.tr),
        content: SizedBox(
          width: 200,
          child: Obx(()=>
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('followSystem'.tr)
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: Container(height: 10,)),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        activeTrackColor: color6(),
                        splashRadius: 0,
                        value: autoDark.value, 
                        onChanged: (val) async {
                          autoDark.value=val;
                          if(val){
                            final Brightness brightness = MediaQuery.of(context).platformBrightness;
                            if(brightness == Brightness.dark){
                              darkMode.value=true;
                            }else{
                              darkMode.value=false;
                            }
                          }
                        }
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text('enableDark'.tr)
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: Container(height: 10,)),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        activeTrackColor: color6(),
                        splashRadius: 0,
                        value: darkMode.value, 
                        onChanged: autoDark.value ? null : (val) async {
                          darkMode.value=val;
                        }
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              darkMode.value=tmpDarkMode;
              autoDark.value=tmpAutoDark;
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs=await SharedPreferences.getInstance();
              prefs.setBool('darkMode', darkMode.value);
              prefs.setBool('autoDark', autoDark.value);
            }, 
            child: Text('ok'.tr)
          )
        ],
      )
    );
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
              prefs.setInt('theme', baseColor.value.toARGB32());
            }, 
            child: Text('ok'.tr)
          )
        ],
      )
    );
  }

  Color color1(){
    if(darkMode.value){
      return const Color.fromARGB(255, 50, 50, 50);
    }

    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.98).toColor();
  }

  Color color2(){
    if(darkMode.value){
      return const Color.fromARGB(255, 60, 60, 60);
    }

    HSLColor baseHSL = HSLColor.fromColor(baseColor.value);
    return baseHSL.withLightness(0.958).toColor();
  }

  Color color3(){
    if(darkMode.value){
      return const Color.fromARGB(255, 80, 80, 80);
    }

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