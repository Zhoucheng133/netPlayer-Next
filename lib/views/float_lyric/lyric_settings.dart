import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/lyric_controller.dart';
import 'package:net_player_next/views/float_lyric/bridge.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLyricSettings(BuildContext context){
  final LyricController lyricController=Get.find();
  TextEditingController fontSizeController=TextEditingController(text: lyricController.fontSize.value.toString());

  int fontSizeTemp=lyricController.fontSize.value;
  int opacityTemp=lyricController.opacity.value;

  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text("floatLyricSettings".tr),
      content: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        spacing: 15,
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Text("fontSize".tr),
              Row(
                spacing: 10,
                children: [
                  Padding(
                    padding: const .only(left: 2),
                    child: SizedBox(
                      width: 80,
                      child: TextField(
                        controller: fontSizeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isCollapsed: true,
                          contentPadding: .all(10)
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onSubmitted: (value){
                          lyricController.fontSize.value=int.parse(fontSizeController.text);
                          FFIBridge.updateFontSize(int.parse(fontSizeController.text));
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Obx(()=>Text("${"opacity".tr}: ${lyricController.opacity.value}%"),),
              Obx(()=>
                SliderTheme(
                  data: SliderThemeData(
                    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.basic),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: 100.0,
                    value: lyricController.opacity.value.toDouble(), 
                    onChanged: (val){
                      lyricController.opacity.value=val.toInt();
                      FFIBridge.updateOpacity(val);
                    }
                  ),
                )
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
            lyricController.fontSize.value=fontSizeTemp;
            lyricController.opacity.value=opacityTemp;
            FFIBridge.updateFontSize(fontSizeTemp);
            FFIBridge.updateOpacity(opacityTemp.toDouble());
            Navigator.pop(context);
          }, 
          child: Text("cancel".tr)
        ),
        ElevatedButton(
          onPressed: () async {
            FFIBridge.updateFontSize(int.parse(fontSizeController.text));
            final prefs=await SharedPreferences.getInstance();
            prefs.setInt("fontSize", int.parse(fontSizeController.text));
            prefs.setInt("opacity", lyricController.opacity.value);
            if(context.mounted) Navigator.pop(context);
          }, 
          child: Text("ok".tr)
        )
      ],
    )
  );
}