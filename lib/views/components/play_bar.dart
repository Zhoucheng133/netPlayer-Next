import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
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

  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;
  bool hoverLove=false;
  bool hoverLyric=false;
  bool hoverVolume=false;
  bool hoverMode=false;

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
      child: Obx(
        ()=>Row(
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
                    if(c.nowPlay['id']!=""){
                      operations.toggleLyric(context);
                    }
                  },
                  child: Tooltip(
                    message: 'showLyric'.tr,
                    waitDuration: const Duration(seconds: 1),
                    child: MouseRegion(
                      cursor: c.nowPlay['id']=="" ? SystemMouseCursors.basic : SystemMouseCursors.click,
                      onEnter: (_){
                        if(c.nowPlay['id']!=""){
                          setState(() {
                            hoverCover=true;
                          });
                        }
                      },
                      onExit: (_){
                        if(c.nowPlay['id']!=""){
                          setState(() {
                            hoverCover=false;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'cover',
                            child: c.coverFuture.value==null ? Image.asset(
                              "assets/blank.jpg",
                              fit: BoxFit.contain,
                            ) : Image.memory(
                              c.coverFuture.value!,
                              fit: BoxFit.contain,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 165,
                  child: Text(
                    c.nowPlay['title'],
                    style: GoogleFonts.notoSansSc(
                      fontWeight: FontWeight.bold,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: Text(
                    c.nowPlay['artist'],
                    style: GoogleFonts.notoSansSc(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
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
                          value: c.nowPlay['duration']==0 ? 0.0 : c.playProgress.value/1000/c.nowPlay["duration"]>1 ? 1.0 : c.playProgress.value/1000/c.nowPlay["duration"]<0 ? 0 : c.playProgress.value/1000/c.nowPlay["duration"],
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
                            c.nowPlay['duration']==0 ? "" : convertDuration(c.playProgress.value~/1000),
                            style: GoogleFonts.notoSansSc(
                              fontSize: 12,
                              color: colorController.color5()
                            ),
                          )
                        ),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            c.nowPlay['duration']==0 ? "" : convertDuration(c.nowPlay['duration']),
                            style: GoogleFonts.notoSansSc(
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
                          operations.deloveSong(context, c.nowPlay['id']);
                        }else{
                          operations.loveSong(context, c.nowPlay['id']);
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
                    const SizedBox(width: 25,),
                    GestureDetector(
                      onTap: (){
                        operations.toggleLyric(context);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverLyric=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverLyric=false;
                          });
                        },
                        child: Tooltip(
                          message: 'showLyric'.tr,
                          waitDuration: const Duration(seconds: 1),
                          child: TweenAnimationBuilder(
                            tween: ColorTween(end: hoverLyric ? colorController.color6() : colorController.color5()),
                            duration: const Duration(milliseconds: 200),
                            builder: (_, value, __)=>Icon(
                              Icons.lyrics_rounded,
                              size: 18,
                              color: value,
                            )
                          ),
                        )
                      ),
                    ),
                    const SizedBox(width: 25,),
                    Obx(()=>
                      CustomPopup(
                        arrowColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                        backgroundColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                        content: SizedBox(
                          height: 25,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Obx(()=>
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MouseRegion(
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
                                        style: GoogleFonts.notoSansSc(
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
                                SizedBox(
                                  width: 18,
                                  child: FaIcon(
                                    c.volume.value > 50 ? FontAwesomeIcons.volumeHigh : c.volume.value==0 ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeLow,
                                    size: 14,
                                    color: value,
                                  ),
                                )
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25,),
                    PopupMenuButton(
                      color: Colors.white,
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