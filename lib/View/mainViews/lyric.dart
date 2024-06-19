// ignore_for_file: camel_case_types

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool hoverLove=false;
  bool hoverLyric=false;
  bool hoverVolume=false;
  bool hoverMode=false;
  final Controller c = Get.put(Controller());

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool isLoved(){
    for (var val in c.lovedSongs) {
      if(val["id"]==c.nowPlay['id']){
        return true;
      }
    }
    return false;
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
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: 300,
                          child: Stack(
                            children: [
                              Obx(()=>
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
                              Positioned(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
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
                                )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(isLoved()){
                                  Operations().deloveSong(context, c.nowPlay['id']);
                                }else{
                                  Operations().loveSong(context, c.nowPlay['id']);
                                }
                                
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverLove=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverLove=false;
                                  });
                                },
                                child: Obx(()=>
                                  !isLoved() ?
                                  TweenAnimationBuilder(
                                    tween: ColorTween(end: hoverLove ? c.color6 : c.color5), 
                                    duration: const Duration(milliseconds: 200), 
                                    builder: (_, value, __)=>Icon(
                                      Icons.favorite_border_outlined,
                                      size: 18,
                                      color: value,
                                    )
                                  ) : const Icon(
                                    Icons.favorite_rounded,
                                    size: 18,
                                    color: Colors.red,
                                  )
                                ),
                              ),
                            ),
                            const SizedBox(width: 25,),
                            CustomPopup(
                              content: SizedBox(
                                width: 120,
                                height: 20,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbColor: c.color6,
                                          overlayColor: Colors.transparent,
                                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                          trackHeight: 2,
                                          thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 5,
                                            elevation: 0,
                                            pressedElevation: 0,
                                          ),
                                          activeTrackColor: c.color5,
                                          inactiveTrackColor: c.color4,
                                        ),
                                        child: Obx(()=>
                                          Slider(
                                            value: c.volume.value/100, 
                                            onChanged: (val){
                                              c.updateVolume((val*100).toInt());
                                              c.handler.volumeSet(c.volume.value);
                                              EasyDebounce.debounce(
                                                'volume', 
                                                const Duration(milliseconds: 50), 
                                                (){
                                                  Operations().saveVolume();
                                                }
                                              );
                                            }
                                          ),
                                        )
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    SizedBox(
                                      width: 35,
                                      child: Obx(()=>
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${c.volume}%",
                                            style: const TextStyle(
                                              fontSize: 12
                                            ),
                                          ),
                                        )
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverVolume=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverVolume=false;
                                  });
                                },
                                child: TweenAnimationBuilder(
                                  tween: ColorTween(end: hoverVolume ? c.color6 : c.color5), 
                                  duration: const Duration(milliseconds: 200), 
                                  builder: (_, value, __)=>Obx(()=>
                                    FaIcon(
                                      c.volume.value > 50 ? FontAwesomeIcons.volumeHigh : c.volume.value==0 ? FontAwesomeIcons.volumeOff : FontAwesomeIcons.volumeLow,
                                      size: 14,
                                      color: value,
                                    )
                                  )
                                ),
                              ),
                            ),
                            const SizedBox(width: 25,),
                            Obx(()=>
                              PopupMenuButton(
                                color: c.color1,
                                tooltip: "",
                                enabled: !c.fullRandom.value,
                                splashRadius: 0,
                                onSelected: (val) async {
                                  c.playMode.value=val;
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  await prefs.setString('playMode', val);
                                },
                                itemBuilder: (BuildContext context)=>[
                                  const PopupMenuItem(
                                    value: "list",
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.repeat_rounded,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5,),
                                        Text("列表播放")
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: "repeat",
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.repeat_one_rounded,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5,),
                                        Text("单曲循环")
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: "random",
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shuffle_rounded,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5,),
                                        Text("随机播放")
                                      ],
                                    ),
                                  )
                                ],
                                child: Container(
                                  color: Colors.white,
                                  child: MouseRegion(
                                    cursor: c.fullRandom.value ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                                    onEnter: (_){
                                      setState(() {
                                        hoverMode=true;
                                      });
                                    },
                                    onExit: (_){
                                      setState(() {
                                        hoverMode=false;
                                      });
                                    },
                                    child: TweenAnimationBuilder(
                                      tween: ColorTween(end: hoverMode ? c.color6 : c.color5), 
                                      duration: const Duration(milliseconds: 200), 
                                      builder: (_, value, __)=>Obx(()=>
                                        c.fullRandom.value ? Icon(
                                          Icons.shuffle,
                                          size: 18,
                                          color: Colors.grey[300],
                                        ) : c.playMode.value=='list' ?  Icon(
                                          Icons.repeat_rounded,
                                          size: 18,
                                          color: value,
                                        ) : c.playMode.value=='repeat' ?
                                        Icon(
                                          Icons.repeat_one_rounded,
                                          size: 18,
                                          color: value
                                        ) : Icon(
                                          Icons.shuffle_rounded,
                                          size: 18,
                                          color: value,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              )
                            )
                          ],
                        ),
                      ],
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: Container(
                        // TODO 歌词内容
                      ),
                    )
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