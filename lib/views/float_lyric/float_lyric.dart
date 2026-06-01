import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/float_lyric/style_var.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final WindowMethodChannel floatLyricChannel = const WindowMethodChannel(
    'net_player_next/float_lyric',
    mode: ChannelMode.unidirectional,
  );

  final RxString currentLyric = ''.obs;

  late SharedPreferences prefs;

  Future<void> closeFloatLyric() async {
    try {
      await mainWindowChannel.invokeMethod('floatLyricClosed');
    } finally {
      await windowManager.hide();
    }
  }

  @override
  Future<void> onWindowMoved() async {
    super.onWindowMoved();
    final offset=await windowManager.getPosition();
    prefs.setDouble('positionX', offset.dx);
    prefs.setDouble('positionY', offset.dy);
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    initFloatLyricChannel();
    initWindow();
  }

  Future<void> initFloatLyricChannel() async {
    await floatLyricChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'lyricChange':
          currentLyric.value = call.arguments?.toString() ?? '';
          return true;
      }
      return null;
    });
  }

  @override
  void dispose() {
    floatLyricChannel.setMethodCallHandler(null);
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> initWindow() async {
    prefs=await SharedPreferences.getInstance();
    await windowManager.setResizable(false);
    await windowManager.setAsFrameless();
  }

  bool inWindows=false;
  bool hoverText=false;
  bool hoverOpacity=false;
  bool hoverPin=true;
  bool hoverClose=false;
  bool hoverMid=false;

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
                          GestureDetector(
                            onTap: () async {
                              Size windowSize = await windowManager.getSize();
                              Offset currentPosition = await windowManager.getPosition();
                              Display display = await screenRetriever.getPrimaryDisplay();
                              double newX = (display.size.width - windowSize.width) / 2;
                              await windowManager.setPosition(Offset(newX, currentPosition.dy));
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_){
                                setState(() {
                                  hoverMid=true;
                                });
                              },
                              onExit: (_){
                                setState(() {
                                  hoverMid=false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 25,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: hoverMid ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 230, 230, 230)
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.alignCenter,
                                    size: 12,
                                    color: Colors.grey[700]
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                      prefs.setInt("fontSize", s.fontSize.value);
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
                                      prefs.setInt("fontSize", s.fontSize.value);
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
                                            prefs.setBool("showShadow", s.showShadow.value);
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
                                            prefs.setBool("showShadow", s.showShadow.value);
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
                                        },
                                        onChangeEnd: (value){
                                          prefs.setInt("opacity", s.opacity.value);
                                        },
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
                              s.alwaysOnTop.value=!s.alwaysOnTop.value;
                              windowManager.setAlwaysOnTop(s.alwaysOnTop.value);
                              prefs.setBool("alwaysOnTop", s.alwaysOnTop.value);
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
                                    color: s.alwaysOnTop.value ? Colors.grey[700] : Colors.grey[400],
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
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(
                        ()=>Stack(
                          children: [
                            Text(
                              currentLyric.value,
                              style: TextStyle(
                                fontSize: s.fontSize.value.toDouble(),
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.fade,
                                fontFamily: "PuHui",
                                foreground: Paint()
                                ..style=PaintingStyle.stroke
                                ..strokeWidth=3
                                ..color=const Color.fromARGB(255, 24, 144, 255)
                              ),
                              softWrap: false,
                            ),
                            Text(
                              currentLyric.value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: s.fontSize.value.toDouble(),
                                color: Colors.white,
                                overflow: TextOverflow.fade,
                                fontFamily: "PuHui"
                              ),
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 25,)
              ],
            ),
          )
        ),
      ),
    );
  }
}
