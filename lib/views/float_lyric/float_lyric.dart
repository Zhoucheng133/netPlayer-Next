import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/float_lyric/style_var.dart';
import 'package:window_manager/window_manager.dart';

class FloatLyric extends StatefulWidget {
  const FloatLyric({super.key});

  @override
  State<FloatLyric> createState() => _FloatLyricState();
}

class _FloatLyricState extends State<FloatLyric> with WindowListener {

  final WindowMethodChannel mainWindowChannel = const WindowMethodChannel(
    'net_player_next/main_window',
    mode: ChannelMode.unidirectional,
  );

  Future<void> closeFloatLyric() async {
    await mainWindowChannel.invokeMethod('floatLyricClosed');
    await windowManager.hide();
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    initWindow();
  }

  Future<void> initWindow() async {
    await windowManager.setAlwaysOnTop(true);
    await windowManager.setResizable(false);
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(false);
  }

  bool inWindows=false;
  bool alwaysOnTop=false;
  bool hoverText=false;
  bool hoverOpacity=false;
  bool hoverPin=true;
  bool hoverClose=false;

  final StyleVar s=Get.put(StyleVar());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'PuHui',
        ),
      ),
      home: Obx(
        ()=> Scaffold(
          backgroundColor: Color.fromARGB(s.opacity.value, 248, 249, 255),
          body: MouseRegion(
            onEnter: (_){
              setState(() {
                inWindows=true;
              });
            },
            onExit: (_){
              setState(() {
                inWindows=false;
              });
            },
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: DragToMoveArea(child: Container())),
                      if(inWindows) Row(
                        children: [
                          CustomPopup(
                            content: SizedBox(
                              width: 120,
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      if(s.fontSize.value<=10){
                                        return;
                                      }
                                      s.fontSize.value-=1;
                                    }, 
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 18,
                                    )
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Obx(()=>
                                        Text(
                                          s.fontSize.value.toString(),
                                          style: const TextStyle(
                                            fontSize: 14
                                          ),
                                        )
                                      )
                                      )
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      if(s.fontSize.value>=25){
                                        return;
                                      }
                                      s.fontSize.value+=1;
                                    }, 
                                    icon: const Icon(
                                      Icons.add,
                                      size: 18,
                                    )
                                  ),
                                ],
                              )
                            ),
                            child: GestureDetector(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverText=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverText=false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: hoverText ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
                                  ),
                                  height: 25,
                                  width: 40,
                                  child: Center(
                                    child: Icon(
                                      Icons.text_fields,
                                      size: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CustomPopup(
                            content: SizedBox(
                              width: 150,
                              height: 60,
                              child: Column(
                                children: [
                                  Obx(()=>
                                    Row(
                                      children: [
                                        Checkbox(
                                          splashRadius: 0,
                                          activeColor: Colors.blue,
                                          value: s.showShadow.value, 
                                          onChanged: (val) async {
                                            s.showShadow.value=val??true;
                                            if(!s.showShadow.value){
                                              await windowManager.setAsFrameless();
                                            }
                                            windowManager.setHasShadow(s.showShadow.value);
                                          }
                                        ),
                                        const SizedBox(width: 10,),
                                        GestureDetector(
                                          onTap: () async {
                                            s.showShadow.value=!s.showShadow.value;
                                            if(!s.showShadow.value){
                                              await windowManager.setAsFrameless();
                                            }
                                            windowManager.setHasShadow(s.showShadow.value);
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: Text('showShadow'.tr)
                                          )
                                        )
                                      ],
                                    )
                                  ),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      thumbColor: Colors.blue,
                                      overlayColor: Colors.transparent,
                                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                      trackHeight: 2,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 7,
                                        elevation: 0,
                                        pressedElevation: 0,
                                      ),
                                      activeTrackColor: Colors.blue[400],
                                      inactiveTrackColor: Colors.blue[200],
                                    ),
                                    child: Obx(()=>
                                      Slider(
                                        value: (s.opacity.value)/255, 
                                        onChanged: (val){
                                          s.opacity.value=(val*255).toInt();
                                        }
                                      )
                                    ),
                                  ),
                                ],
                              )
                            ),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_){
                                setState(() {
                                  hoverOpacity=true;
                                });
                              },
                              onExit: (_){
                                setState(() {
                                  hoverOpacity=false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 25,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: hoverOpacity ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.droplet,
                                    size: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                alwaysOnTop=!alwaysOnTop;
                              });
                              windowManager.setAlwaysOnTop(alwaysOnTop);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_){
                                setState(() {
                                  hoverPin=true;
                                });
                              },
                              onExit: (_){
                                setState(() {
                                  hoverPin=false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 25,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: hoverPin ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.thumbtack,
                                    size: 12,
                                    color: alwaysOnTop ? Colors.grey[700] : Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              closeFloatLyric();
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_){
                                setState(() {
                                  hoverClose=true;
                                });
                              },
                              onExit: (_){
                                setState(() {
                                  hoverClose=false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: hoverClose ? const Color.fromARGB(255, 210, 0, 0) : const Color.fromARGB(0, 230, 230, 230)
                                ),
                                height: 25,
                                width: 40,
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: 14,
                                    color: hoverClose ? Colors.white : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}