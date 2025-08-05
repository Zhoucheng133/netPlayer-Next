import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/lyric_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
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
  bool hoverAdd=false;
  bool hoverLyric=false;
  bool hoverVolume=false;
  bool hoverMode=false;
  bool hoverTip=false;
  bool hoverFont=false;
  final LyricController lyricController=Get.put(LyricController());
  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  final operations=Operations();
  final SongController songController=Get.find();

  bool playedLyric(index){
    if(c.lyric.length==1){
      return true;
    }
    bool flag=false;
    try {
      // flag=c.playProgress.value>=c.lyric[index]['time'] && c.playProgress<c.lyric[index+1]['time'];
      flag=c.playProgress.value>=c.lyric[index].time && c.playProgress<c.lyric[index+1].time;
    } catch (_) {
      if(c.lyric.length==index+1 && c.playProgress.value>=c.lyric[index].time){
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
    for (var val in songController.lovedSongs) {
      if(val.id==songController.nowPlay.value.id){
        return true;
      }
    }
    return false;
  }

  late Worker lyricLineListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lyricLineListener=ever(c.lyricLine, (val){
        lyricController.scrollLyric();
      });
      lyricController.scrollLyric();
    });
  }
  
  @override
  void dispose() {
    lyricLineListener.dispose();
    super.dispose();
  }

  void showArtistOp(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'copyArtist'.tr,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
              leading: const Icon(
                Icons.copy_rounded,
                size: 20,
              ),
              onTap: (){
                Navigator.pop(context);
                FlutterClipboard.copy(songController.nowPlay.value.artist).then((_){
                  if(context.mounted){
                    showMessage(true, 'copied'.tr, context);
                  }
                });
              },
            ),
            ListTile(
              title: Text(
                'showArtist'.tr,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
              leading: const Icon(
                Icons.mic_rounded,
                size: 20,
              ),
              onTap: (){
                Navigator.pop(context);
                operations.toArtist(context);
              },
            ),
          ],
        ),
      )
    );
  }

  void showTitleOp(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'copyTitle'.tr,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
              leading: const Icon(
                Icons.copy_rounded,
                size: 20,
              ),
              onTap: (){
                Navigator.pop(context);
                FlutterClipboard.copy(songController.nowPlay.value.title).then((_){
                  if(context.mounted){
                    showMessage(true, 'copied'.tr, context);
                  }
                });
              },
            ),
            ListTile(
              title: Text(
                'showAlbum'.tr,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
              leading: const Icon(
                Icons.album_rounded,
                size: 20,
              ),
              onTap: (){
                Navigator.pop(context);
                operations.toAlbum(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>
        Container(
          color: colorController.darkMode.value ? colorController.color1() : Colors.white,
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
                  child: Platform.isWindows ? AnimatedOpacity(
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
                  ) : Container()
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
                                  c.coverFuture.value==null ? Image.asset(
                                    "assets/blank.jpg",
                                    fit: BoxFit.contain,
                                  ) : Image.memory(
                                    c.coverFuture.value!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                showTitleOp(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Obx(()=>
                                  Text(
                                    songController.nowPlay.value.title,
                                    style: GoogleFonts.notoSansSc(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: colorController.darkMode.value ? Colors.white : Colors.black,
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
                                showArtistOp(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Obx(()=>
                                  Text(
                                    songController.nowPlay.value.artist,
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
                                      child: Obx(()=>
                                        TweenAnimationBuilder(
                                          tween: ColorTween(end: hoverPre ? colorController.color6() : colorController.color5()), 
                                          duration: const Duration(milliseconds: 200),
                                          builder: (_, value, __) => Icon(
                                            Icons.skip_previous_rounded,
                                            color: value,
                                            size: 30,
                                          ),
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
                                      child: Obx(()=>
                                        AnimatedContainer(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(23),
                                            color: hoverPause ? colorController.color6() : colorController.color5()
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
                                      child: Obx(()=>
                                        TweenAnimationBuilder(
                                          tween: ColorTween(end: hoverSkip ? colorController.color6() : colorController.color5()), 
                                          duration: const Duration(milliseconds: 200),
                                          builder: (_, value, __) => Icon(
                                            Icons.skip_next_rounded,
                                            color: value,
                                            size: 30,
                                          ),
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
                                        thumbColor: colorController.color6(),
                                        activeTrackColor: colorController.color5(),
                                        inactiveTrackColor: colorController.color3(),
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
                                              songController.nowPlay.value.duration==0 ? "" : convertDuration(c.playProgress.value~/1000),
                                              style: GoogleFonts.notoSansSc(
                                                fontSize: 12,
                                                color: colorController.color5()
                                              ),
                                            )
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Obx(()=>
                                            Text(
                                              songController.nowPlay.value.duration==0 ? "" : convertDuration(songController.nowPlay.value.duration),
                                              style: GoogleFonts.notoSansSc(
                                                fontSize: 12,
                                                color: colorController.color5()
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
                            SizedBox(
                              width: 150,
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
                                          child: Obx(()=>
                                            !isLoved() ?
                                            Tooltip(
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
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Obx(()=>
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
                                      child: Obx(()=>
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
                                            color: colorController.darkMode.value ? colorController.color1() : Colors.white,
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
                                                child: Obx(()=>
                                                  TweenAnimationBuilder(
                                                    tween: ColorTween(end: hoverMode ? colorController.color6() : colorController.color5()), 
                                                    duration: const Duration(milliseconds: 200), 
                                                    builder: (_, value, __)=> Obx(()=>
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
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        )
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          if(c.playLists.isEmpty){
                                            showDialog(
                                              context: context, 
                                              builder: (context)=>AlertDialog(
                                                title: Text('addPlayListErr'.tr),
                                                content: Text('playListEmpty'.tr),
                                                actions: [
                                                  ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('ok'.tr))
                                                ],
                                              )
                                            );
                                            return;
                                          }
                                          String selectedItem=c.playLists[0]["id"];
                                          await showDialog(
                                            context: context, 
                                            builder: (BuildContext context)=>AlertDialog(
                                              title: Text('addToList'.tr),
                                              content: StatefulBuilder(
                                                builder: (BuildContext context, StateSetter setState)=>DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    buttonStyleData: ButtonStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                      )
                                                    ),
                                                    dropdownStyleData: DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                      )
                                                    ),
                                                    value: selectedItem,
                                                    items: List.generate(c.playLists.length, (index){
                                                      return DropdownMenuItem(
                                                        value: c.playLists[index]["id"],
                                                        child: Text(c.playLists[index]["name"]),
                                                      );
                                                    }),
                                                    onChanged: (val){
                                                      setState((){
                                                        selectedItem=val as String;
                                                      });
                                                    },
                                                  ),
                                                )
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  }, 
                                                  child: Text('cancel'.tr)
                                                ),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    operations.addToList(context, songController.nowPlay.value.id, selectedItem);
                                                    Navigator.pop(context);
                                                  }, 
                                                  child: Text('add'.tr)
                                                )
                                              ],
                                            )
                                          );
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_)=>setState(() {
                                            hoverAdd=true;
                                          }),
                                          onExit: (_)=>setState(() {
                                            hoverAdd=false;
                                          }),
                                          child: Tooltip(
                                            message: 'addToList'.tr,
                                            child: TweenAnimationBuilder(
                                              tween: ColorTween(end: hoverAdd ? colorController.color6() : colorController.color5()), 
                                              duration: const Duration(milliseconds: 200), 
                                              builder: (_, value, __)=>Icon(
                                                Icons.add_rounded,
                                                size: 20,
                                                color: value,
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  )
                                ],
                              ),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 7),
                                          child: AutoScrollTag(
                                            key: ValueKey(index), 
                                            controller: lyricController.controller.value, 
                                            index: index,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SelectableText(
                                                  c.lyric[index].lyric,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSansSc(
                                                    fontSize: c.lyricText.value.toDouble(),
                                                    color: playedLyric(index) ? colorController.color5() : colorController.color3(),
                                                    fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                                  ),
                                                ),
                                                if(c.lyric[index].translate.isNotEmpty && c.lyricTranslate.value) SelectableText(
                                                  c.lyric[index].translate,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSansSc(
                                                    fontSize: c.lyricText.value.toDouble()*0.85,
                                                    color: playedLyric(index) ? colorController.color5() : colorController.color3(),
                                                    fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                                  ),
                                                )
                                              ],
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
                                Obx(()=>
                                  CustomPopup(
                                    arrowColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                                    backgroundColor: colorController.darkMode.value ? colorController.color3() : Colors.white,
                                    content: SizedBox(
                                      height: 25,
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
                                      child: Obx(()=>
                                        TweenAnimationBuilder(
                                          tween: ColorTween(end: hoverFont ? colorController.color6() : colorController.color4()), 
                                          duration: const Duration(milliseconds: 200),
                                          builder: (_, value, __)=>Icon(
                                            Icons.text_fields_rounded,
                                            size: 20,
                                            color: value,
                                          )
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15,),
                                Obx(()=>
                                  Tooltip(
                                    preferBelow: false,
                                    message: "${'lyricTip'.tr}${c.lyricFrom.value==LyricFrom.netease ? '\n${'lyricNetease'.tr}' : c.lyricFrom.value==LyricFrom.lrclib ? '\n${'lyricLrclib'.tr}' : ''}",
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
                                      child: Obx(()=>
                                        TweenAnimationBuilder(
                                          tween: ColorTween(end: hoverTip ? colorController.color6() : colorController.color4()), 
                                          duration: const Duration(milliseconds: 200), 
                                          builder: (_, value, __)=>Icon(
                                            Icons.info_rounded,
                                            size: 20,
                                            color: value,
                                          )
                                        ),
                                      ),
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
                      child: Obx(()=>
                        TweenAnimationBuilder(
                          tween: ColorTween(end: hoverBack ? colorController.color6() : colorController.color4()), 
                          duration: const Duration(milliseconds: 200),
                          builder: (_, value, __)=>Icon(
                            Icons.arrow_downward_rounded,
                            color: value,
                          )
                        ),
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}