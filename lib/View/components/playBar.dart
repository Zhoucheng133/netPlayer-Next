// ignore_for_file: camel_case_types, file_names

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class playBar extends StatefulWidget {
  const playBar({super.key});

  @override
  State<playBar> createState() => _playBarState();
}

class _playBarState extends State<playBar> {

  final Controller c = Get.put(Controller());

  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;

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

  

  bool hoverCover=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 封面
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: GestureDetector(
                onTap: (){
                  Operations().toggleLyric(context);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_){
                    setState(() {
                      hoverCover=true;
                    });
                  },
                  onExit: (_){
                    setState(() {
                      hoverCover=false;
                    });
                  },
                  child: Stack(
                    children: [
                      Hero(
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: hoverCover ? const Color.fromARGB(80, 0, 0, 0) : const Color.fromARGB(0, 0, 0, 0)
                        ),
                        child: Center(
                          child: TweenAnimationBuilder(
                            tween: ColorTween(end: hoverCover ? Colors.white : Colors.white.withAlpha(0),), 
                            duration: const Duration(milliseconds: 200), 
                            builder: (_, value, __)=>Icon(
                              Icons.arrow_upward_rounded,
                              color: value,
                              size: 18,
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
          const SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 165,
                child: Obx(() => 
                  Text(
                    c.nowPlay['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              SizedBox(
                width: 165,
                child: Obx(()=>
                  Text(
                    c.nowPlay['artist'],
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
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
                                    height: 34,
                                    width: 34,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: hoverPause ? c.color6 : c.color5
                                    ),
                                    duration: const Duration(milliseconds: 200),
                                    child: Center(
                                      child: Obx(()=>
                                        c.isPlay.value ? const Icon(
                                          Icons.pause_rounded,
                                          color: Colors.white,
                                        ): const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
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
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
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
                    )
                  ],
                ),
                Positioned(
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
                  )
                )
              ]
            )
          ),
          const SizedBox(width: 10,),
          SizedBox(
            width: 210,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
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
                      child: Obx(()=>
                        !isLoved() ?
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 18,
                          color: c.color5,
                        ) : const Icon(
                          Icons.favorite_rounded,
                          size: 18,
                          color: Colors.red,
                        )
                      ),
                    ),
                  ),
                  const SizedBox(width: 25,),
                  GestureDetector(
                    onTap: (){
                      Operations().toggleLyric(context);
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.lyrics_rounded,
                        size: 18,
                        color: c.color5,
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
                      child: Obx(()=>
                        FaIcon(
                          c.volume.value > 50 ? FontAwesomeIcons.volumeHigh : c.volume.value==0 ? FontAwesomeIcons.volumeOff : FontAwesomeIcons.volumeLow,
                          size: 14,
                          color: c.color5,
                        ),
                      )
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
                        color: c.color1,
                        child: Obx(()=>
                          c.fullRandom.value ? Icon(
                            Icons.shuffle,
                            size: 18,
                            color: Colors.grey[300],
                          ) : c.playMode.value=='list' ?  Icon(
                            Icons.repeat_rounded,
                            size: 18,
                            color: c.color5,
                          ) : c.playMode.value=='repeat' ?
                          Icon(
                            Icons.repeat_one_rounded,
                            size: 18,
                            color: c.color5,
                          ) : Icon(
                            Icons.shuffle_rounded,
                            size: 18,
                            color: c.color5,
                          ),
                        ),
                      )
                    )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}