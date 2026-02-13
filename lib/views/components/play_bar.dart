import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/play_queue.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({super.key});

  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {

  final Controller c = Get.find();
  Operations operations=Operations();
  final ColorController colorController=Get.find();
  final SongController songController=Get.find();

  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;
  bool hoverLove=false;
  bool hoverLyric=false;
  bool hoverVolume=false;
  bool hoverMode=false;
  bool hoverList=false;

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool isLoved(){
    for (var val in songController.lovedSongs) {
      if(val.id==songController.nowPlay.value.id){
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
      child: Obx(
        ()=>Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 封面
            SizedBox(
              width: 45,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: GestureDetector(
                  onTap: (){
                    if(songController.nowPlay.value.id!=""){
                      operations.toggleLyric(context);
                    }
                  },
                  child: Tooltip(
                    message: 'showLyric'.tr,
                    waitDuration: const Duration(seconds: 1),
                    child: MouseRegion(
                      cursor: songController.nowPlay.value.id=="" ? SystemMouseCursors.basic : SystemMouseCursors.click,
                      onEnter: (_){
                        if(songController.nowPlay.value.id!=""){
                          setState(() {
                            hoverCover=true;
                          });
                        }
                      },
                      onExit: (_){
                        if(songController.nowPlay.value.id!=""){
                          setState(() {
                            hoverCover=false;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: Hero(
                              tag: 'cover',
                              child: songController.nowPlay.value.id=="" ? Image.asset(
                                "assets/blank.jpg",
                                fit: BoxFit.contain,
                              ) : Image.network(
                                "${c.userInfo.value.url}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${songController.nowPlay.value.id}&size=400",
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
                ),
              )
            ),
            const SizedBox(width: 10,),
            SizedBox(
              width: 165,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    songController.nowPlay.value.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                  const SizedBox(height: 3,),
                  Text(
                    songController.nowPlay.value.artist,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )
                ],
              ),
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
                                    operations.skipPre();
                                  },
                                  child: Tooltip(
                                    waitDuration: const Duration(seconds: 1),
                                    message: 'skipPre'.tr,
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
                                        tween: ColorTween(end: hoverPre ? colorController.color6() : colorController.color5()),
                                        duration: const Duration(milliseconds: 200),
                                        builder: (_, value, __) => Icon(
                                          Icons.skip_previous_rounded,
                                          color: value,
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15,),
                                GestureDetector(
                                  onTap: (){
                                    operations.toggleSong();
                                  },
                                  child: Tooltip(
                                    waitDuration: const Duration(seconds: 1),
                                    message: 'play/pause'.tr,
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
                                          color: hoverPause ? colorController.color6() : colorController.color5()
                                        ),
                                        duration: const Duration(milliseconds: 200),
                                        child: Center(
                                          child: c.isPlay.value ? const Icon(
                                            Icons.pause_rounded,
                                            color: Colors.white,
                                          ): const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15,),
                                GestureDetector(
                                  onTap: (){
                                    operations.skipNext();
                                  },
                                  child: Tooltip(
                                    waitDuration: const Duration(seconds: 1),
                                    message: 'skipNext'.tr,
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
                                        tween: ColorTween(end: hoverSkip ? colorController.color6() : colorController.color5()),
                                        duration: const Duration(milliseconds: 200),
                                        builder: (_, value, __) => Icon(
                                          Icons.skip_next_rounded,
                                          color: value,
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
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
                          thumbColor: colorController.color6(),
                          activeTrackColor: colorController.color5(),
                          inactiveTrackColor: colorController.color4(),
                        ),
                        child: Slider(
                          value: songController.nowPlay.value.duration==0 ? 0.0 : c.playProgress.value/1000/songController.nowPlay.value.duration>1 ? 1.0 : c.playProgress.value/1000/songController.nowPlay.value.duration<0 ? 0 : c.playProgress.value/1000/songController.nowPlay.value.duration,
                          onChanged: (value){
                            operations.seekChange(value);
                          },
                          onChangeEnd: (value){
                            operations.seekSong(value);
                          },
                        ),
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
                          child: Text(
                            songController.nowPlay.value.duration==0 ? "" : convertDuration(c.playProgress.value~/1000),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorController.color5()
                            ),
                          )
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            songController.nowPlay.value.duration==0 ? "" : convertDuration(songController.nowPlay.value.duration),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorController.color5()
                            ),
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
              width: 220,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 25.0,
                  children: [
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: (){
                            if(isLoved()){
                              operations.deloveSong(context, songController.nowPlay.value.id);
                            }else{
                              operations.loveSong(context, songController.nowPlay.value.id);
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
                            child: !isLoved() ? Tooltip(
                              message: 'love'.tr,
                              waitDuration: const Duration(seconds: 1),
                              child: TweenAnimationBuilder(
                                tween: ColorTween(end: hoverLove ? colorController.color6() : colorController.color5()),
                                duration: const Duration(milliseconds: 200),
                                builder: (_, value, __)=>Icon(
                                  Icons.favorite_border_outlined,
                                  size: 18,
                                  color: value,
                                )
                              ),
                            ) : Tooltip(
                              message: 'delove'.tr,
                              waitDuration: const Duration(seconds: 1),
                              child: TweenAnimationBuilder(
                                tween: ColorTween(end: hoverLove ? Colors.red[700] : Colors.red),
                                duration: const Duration(milliseconds: 200),
                                builder: (_, value, __)=>Icon(
                                  Icons.favorite_rounded,
                                  size: 18,
                                  color: value,
                                )
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Obx(()=>
                          CustomPopup(
                            arrowColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                            backgroundColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                            content: Listener(
                              onPointerSignal: (event) {
                                if (event is PointerScrollEvent) {
                                  c.volume.value = (c.volume.value + (event.scrollDelta.dy * 0.1)).clamp(0, 100).toInt();
                                  c.handler.volumeSet(c.volume.value);
                                  operations.saveVolume();
                                }
                              },
                              child: SizedBox(
                                height: 25,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Obx(()=>
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                          child: Center(
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (c.volume.value > 0) {
                                                    c.lastVolume = c.volume.value;
                                                    c.volume.value=0;
                                                  } else {
                                                    c.volume.value=c.lastVolume;
                                                  }
                                                  c.handler.volumeSet(c.volume.value);
                                                  operations.saveVolume();
                                                },
                                                child: Tooltip(
                                                  message: c.volume.value == 0 ? 'unmute'.tr : 'mute'.tr,
                                                  child: FaIcon(
                                                    c.volume.value > 50 ? FontAwesomeIcons.volumeHigh : c.volume.value==0 ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeLow,
                                                    size: 14,
                                                    color: colorController.color5(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8,),
                                        SizedBox(
                                          width: 80,
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              thumbColor: colorController.color6(),
                                              overlayColor: Colors.transparent,
                                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                                              trackHeight: 2,
                                              thumbShape: const RoundSliderThumbShape(
                                                enabledThumbRadius: 5,
                                                elevation: 0,
                                                pressedElevation: 0,
                                              ),
                                              activeTrackColor: colorController.color5(),
                                              inactiveTrackColor: colorController.color4(),
                                            ),
                                            child: Slider(
                                              value: c.volume.value/100,
                                              onChanged: (val){
                                                c.volume.value=(val*100).toInt();
                                                c.handler.volumeSet(c.volume.value);
                                              },
                                              onChangeEnd: (_){
                                                operations.saveVolume();
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        SizedBox(
                                          width: 35,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${c.volume.value}%",
                                              style: const TextStyle(
                                                fontSize: 12
                                              ),
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            child: Tooltip(
                              waitDuration: const Duration(seconds: 1),
                              message: 'adjustVolume'.tr,
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
                                  tween: ColorTween(end: hoverVolume ? colorController.color6() : colorController.color5()),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (_, value, __) => Obx(()=>
                                    FaIcon(
                                      c.volume.value > 50 ? FontAwesomeIcons.volumeHigh : c.volume.value==0 ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeLow,
                                      size: 14,
                                      color: value,
                                    )
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: PopupMenuButton(
                          color: colorController.darkMode.value ? colorController.color3() : Colors.white,
                          tooltip: "",
                          enabled: !c.fullRandom.value,
                          splashRadius: 0,
                          onSelected: (val) async {
                            c.playMode.value=val;
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('playMode', val);
                          },
                          itemBuilder: (BuildContext context)=>[
                            PopupMenuItem(
                              value: "list",
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.repeat_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("loop".tr)
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "repeat",
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.repeat_one_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("single".tr)
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "random",
                              height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.shuffle_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5,),
                                  Text("shuffle".tr)
                                ],
                              ),
                            )
                          ],
                          child: Container(
                            color: colorController.color1(),
                            child: Tooltip(
                              waitDuration: const Duration(seconds: 1),
                              message: c.fullRandom.value ? 'nowFullShuffle'.tr : 'playMode'.tr,
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
                                  tween: ColorTween(end: hoverMode ? colorController.color6() : colorController.color5()),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (_, value, __)=>c.fullRandom.value ? Icon(
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomPopup(
                        arrowColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                        backgroundColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                        contentPadding: EdgeInsets.zero,
                        content: const SizedBox(
                          height: 400,
                          width: 300,
                          child: PlayQueue(),
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_)=>setState(() {
                            hoverList=true;
                          }),
                          onExit: (_)=>setState(() {
                            hoverList=false;
                          }),
                          child:  Tooltip(
                            message: "playqueue".tr,
                            child: TweenAnimationBuilder(
                              tween: ColorTween(end: hoverList ? colorController.color6() : colorController.color5()),
                              duration: const Duration(milliseconds: 200),
                              builder: (_, value, __) => Icon(
                                Icons.playlist_play_rounded,
                                color: value,
                              )
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}