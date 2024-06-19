// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:window_manager/window_manager.dart';

class lyricView extends StatefulWidget {
  const lyricView({super.key});

  @override
  State<lyricView> createState() => _lyricViewState();
}

class _lyricViewState extends State<lyricView> with WindowListener {

  bool hoverBack=false;
  bool hoverTitleBar=false;
  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;
  final Controller c = Get.put(Controller());

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            MouseRegion(
              onEnter: (_){
                setState(() {
                  hoverTitleBar=true;
                });
              },
              onExit: (_){
                setState(() {
                  hoverTitleBar=false;
                });
              },
              child: SizedBox(
                height: 30,
                child: AnimatedOpacity(
                  opacity: hoverTitleBar?1:0,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: DragToMoveArea(child: Container())
                      ),
                      WindowCaptionButton.minimize(
                        onPressed: (){
                          windowManager.minimize();
                        },
                      ),
                      Obx(()=>
                        c.maxWindow.value ? WindowCaptionButton.unmaximize(
                          onPressed: (){
                            windowManager.unmaximize();
                          }
                        ) : 
                        WindowCaptionButton.maximize(
                          onPressed: (){
                            windowManager.maximize();
                          },
                        ),
                      ),
                      WindowCaptionButton.close(
                        onPressed: (){
                          Operations().closeWindow();
                        },
                      )
                    ],
                  ),
                )
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Hero(
                            tag: 'cover',
                            child: Obx(() =>
                              c.nowPlay["id"]=="" ? 
                              Container(
                                color: c.color1,
                              ) : Image.network(
                                "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Obx(()=>
                          Text(
                            c.nowPlay['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          )
                        ),
                        const SizedBox(height: 5,),
                        Obx(()=>
                          Text(
                            c.nowPlay['artist'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400]
                            ),
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          )
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Operations().skipPre();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverPre=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverPre=false;
                                  });
                                },
                                child: TweenAnimationBuilder(
                                  tween: ColorTween(end: hoverPre ? c.color6 : c.color5), 
                                  duration: const Duration(milliseconds: 200),
                                  builder: (_, value, __) => Icon(
                                    Icons.skip_previous_rounded,
                                    color: value,
                                    size: 30,
                                  ),
                                )
                              ),
                            ),
                            const SizedBox(width: 15,),
                            GestureDetector(
                              onTap: (){
                                Operations().toggleSong();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverPause=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverPause=false;
                                  });
                                },
                                child: AnimatedContainer(
                                  height: 46,
                                  width: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(23),
                                    color: hoverPause ? c.color6 : c.color5
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  child: Center(
                                    child: Obx(()=>
                                      c.isPlay.value ? const Icon(
                                        Icons.pause_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      ): const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 35,
                                      )
                                    )
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            GestureDetector(
                              onTap: (){
                                Operations().skipNext();
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverSkip=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverSkip=false;
                                  });
                                },
                                child: TweenAnimationBuilder(
                                  tween: ColorTween(end: hoverSkip ? c.color6 : c.color5), 
                                  duration: const Duration(milliseconds: 200),
                                  builder: (_, value, __) => Icon(
                                    Icons.skip_next_rounded,
                                    color: value,
                                    size: 30,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 50, right: 50),
                              child: Obx(()=>
                                SliderTheme(
                                  data: SliderThemeData(
                                    overlayColor: Colors.transparent,
                                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                    trackHeight: 1,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 5,
                                      elevation: 0,
                                      pressedElevation: 0,
                                    ),
                                    thumbColor: c.color6,
                                    activeTrackColor: c.color5,
                                    inactiveTrackColor: c.color4,
                                  ),
                                  child: Slider(
                                    value: c.nowPlay['duration']==0 ? 0.0 : c.playProgress.value/1000/c.nowPlay["duration"]>1 ? 1.0 : c.playProgress.value/1000/c.nowPlay["duration"]<0 ? 0 : c.playProgress.value/1000/c.nowPlay["duration"], 
                                    onChanged: (value){
                                      Operations().seekSong(value);
                                    }
                                  ),
                                )
                              ),
                            ),
                            Positioned(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50, right: 50, top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Obx(()=>
                                        Text(
                                          c.nowPlay['duration']==0 ? "" : convertDuration(c.playProgress.value~/1000),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: c.color5
                                          ),
                                        )
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Obx(()=>
                                        Text(
                                          c.nowPlay['duration']==0 ? "" : convertDuration(c.nowPlay['duration']),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: c.color5
                                          ),
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              )
                            )
                          ],
                        )
                      ],
                    )
                  ),
                  Expanded(
                    child: Container()
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: (){
                  Operations().toggleLyric(context);
                },
                child: MouseRegion(
                  onEnter: (_){
                    setState(() {
                      hoverBack=true;
                    });
                  },
                  onExit: (_){
                    setState(() {
                      hoverBack=false;
                    });
                  },
                  cursor: SystemMouseCursors.click,
                  child: TweenAnimationBuilder(
                    tween: ColorTween(end: hoverBack ? c.color6 : c.color4), 
                    duration: const Duration(milliseconds: 200),
                    builder: (_, value, __)=>Icon(
                      Icons.arrow_downward_rounded,
                      color: value,
                    )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}