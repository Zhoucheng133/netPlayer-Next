import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/lyric_controller.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class LyricView extends StatefulWidget {
  const LyricView({super.key});

  @override
  State<LyricView> createState() => _LyricViewState();
}

class _LyricViewState extends State<LyricView> {

  bool hoverBack=false;
  bool hoverTitleBar=false;
  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;
  bool hoverLove=false;
  bool hoverLyric=false;
  bool hoverVolume=false;
  bool hoverMode=false;
  bool hoverTip=false;
  bool hoverFont=false;
  final LyricController lyricController=Get.put(LyricController());
  final Controller c = Get.put(Controller());
  final operations=Operations();

  bool playedLyric(index){
    if(c.lyric.length==1){
      return true;
    }
    bool flag=false;
    try {
      flag=c.playProgress.value>=c.lyric[index]['time'] && c.playProgress<c.lyric[index+1]['time'];
    } catch (_) {
      if(c.lyric.length==index+1 && c.playProgress.value>=c.lyric[index]['time']){
        flag=true;
      }else{
        flag=false;
      }
    }
    return flag;
  }

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

  late Worker lyricLineListener;

  @override
  void initState() {
    super.initState();
    lyricLineListener=ever(c.lyricLine, (val){
      lyricController.scrollLyric();
    });
    lyricController.scrollLyric();
  }
  
  @override
  void dispose() {
    lyricLineListener.dispose();
    super.dispose();
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
                          operations.closeWindow();
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
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
                          GestureDetector(
                            onTap: (){
                              operations.toAlbum(context);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Obx(()=>
                                Text(
                                  c.nowPlay['title'],
                                  style: GoogleFonts.notoSansSc(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                )
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          GestureDetector(
                            onTap: (){
                              operations.toArtist(context);
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Obx(()=>
                                Text(
                                  c.nowPlay['artist'],
                                  style: GoogleFonts.notoSansSc(
                                    fontSize: 13,
                                    color: Colors.grey[400]
                                  ),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                )
                              ),
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Row(
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
                                        operations.seekChange(value);
                                      },
                                      onChangeEnd: (value){
                                        operations.seekSong(value);
                                      },
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
                                            style: GoogleFonts.notoSansSc(
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
                                            style: GoogleFonts.notoSansSc(
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
                                  child: Obx(()=>
                                    !isLoved() ?
                                    Tooltip(
                                      message: 'love'.tr,
                                      waitDuration: const Duration(seconds: 1),
                                      child: TweenAnimationBuilder(
                                        tween: ColorTween(end: hoverLove ? c.color6 : c.color5), 
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
                                              },
                                              onChangeEnd: (_){
                                                operations.saveVolume();
                                              },
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
                                              style: GoogleFonts.notoSansSc(
                                                fontSize: 12
                                              ),
                                            ),
                                          )
                                        ),
                                      )
                                    ],
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
                                    color: Colors.white,
                                    child: Tooltip(
                                      waitDuration: const Duration(seconds: 1),
                                      message: 'playMode'.tr,
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
                                    ),
                                  )
                                )
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50, right: 20, bottom: 30),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                            child: Obx(() => 
                              ListView.builder(
                                controller: lyricController.controller.value,
                                itemCount: c.lyric.length,
                                itemBuilder: (BuildContext context, int index) => 
                                Column(
                                  children: [
                                    index==0 ? SizedBox(height: (MediaQuery.of(context).size.height-160)/2,) : Container(),
                                    Obx(() => 
                                      AutoScrollTag(
                                        key: ValueKey(index), 
                                        controller: lyricController.controller.value, 
                                        index: index,
                                        child: Text(
                                          c.lyric[index]['content'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.notoSansSc(
                                            fontSize: c.lyricText.value.toDouble(),
                                            height: 2.3,
                                            color: playedLyric(index) ? c.color5:c.color3,
                                            fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    ),
                                    index==c.lyric.length-1 ? SizedBox(height: (MediaQuery.of(context).size.height-60-25-130-18)/2,) : Container(),
                                  ],
                                )
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomPopup(
                                content: SizedBox(
                                  height: 20,
                                  width: 100,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          c.lyricText.value-=1;
                                        },
                                        child: const MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Icon(Icons.remove_rounded)
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(child: Obx(()=>Text(c.lyricText.value.toString()))),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          c.lyricText.value+=1;
                                        },
                                        child: const MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Icon(Icons.add_rounded)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_){
                                    setState(() {
                                      hoverFont=true;
                                    });
                                  },
                                  onExit: (_){
                                    setState(() {
                                      hoverFont=false;
                                    });
                                  },
                                  child: TweenAnimationBuilder(
                                    tween: ColorTween(end: hoverFont ? c.color6 : c.color4), 
                                    duration: const Duration(milliseconds: 200),
                                    builder: (_, value, __)=>Icon(
                                      Icons.text_fields_rounded,
                                      size: 20,
                                      color: value,
                                    )
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              Tooltip(
                                message: 'lyricTip'.tr,
                                child: MouseRegion(
                                  onEnter: (_){
                                    setState(() {
                                      hoverTip=true;
                                    });
                                  },
                                  onExit: (_){
                                    setState(() {
                                      hoverTip=false;
                                    });
                                  },
                                  child: TweenAnimationBuilder(
                                    tween: ColorTween(end: hoverTip ? c.color6 : c.color4), 
                                    duration: const Duration(milliseconds: 200), 
                                    builder: (_, value, __)=>Icon(
                                      Icons.info_rounded,
                                      size: 20,
                                      color: value,
                                    )
                                  ),
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: (){
                  operations.toggleLyric(context);
                },
                child: Tooltip(
                  message: 'hideLyric'.tr,
                  waitDuration: const Duration(seconds: 1),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}