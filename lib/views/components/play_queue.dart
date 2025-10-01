import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PlayQueue extends StatefulWidget {
  const PlayQueue({super.key});

  @override
  State<PlayQueue> createState() => _PlayQueueState();
}

class _PlayQueueState extends State<PlayQueue> {

  final SongController songController=Get.find();
  final ColorController colorController=Get.find();
  final Controller c=Get.find();
  final AutoScrollController controller=AutoScrollController();
  bool hoverLocate=false;

  void locateSong(){
    controller.scrollToIndex(songController.nowPlay.value.index, preferPosition: AutoScrollPosition.middle);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> c.fullRandom.value ? Center(
        child: Text('queueNotAvaliable'.tr),
      ) : Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'playqueue'.tr,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 16
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: ()=>locateSong(),
                    child: Tooltip(
                      waitDuration: const Duration(seconds: 1),
                      message: 'locate'.tr,
                      child: Obx(()=>
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_){
                            setState(() {
                              hoverLocate=true;
                            });
                          },
                          onExit: (_){
                            setState(() {
                              hoverLocate=false;
                            });
                          },
                          child: TweenAnimationBuilder(
                            tween: ColorTween(end:  hoverLocate ? colorController.color6() : colorController.color5()), 
                            duration: const Duration(milliseconds: 200), 
                            builder: (_, value, __) => Icon(
                              Icons.my_location_rounded,
                              size: 17,
                              color: value,
                            )
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: songController.nowPlay.value.list.length,
                itemBuilder: (item, index)=>AutoScrollTag(
                  key: ValueKey(index),
                  controller: controller,
                  index: index,
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Center(
                            child: songController.nowPlay.value.list[index].id==songController.nowPlay.value.id ? Icon(
                              Icons.play_arrow_rounded,
                              color: colorController.color6(),
                              size: 15,
                            ) : Text(
                              (index+1).toString(),
                              style: GoogleFonts.notoSansSc(
                                fontSize: 13,
                                color: colorController.darkMode.value ? Colors.white : Colors.black,
                              ),
                            ),
                          )
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Text(
                            songController.nowPlay.value.list[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansSc(
                              color: songController.nowPlay.value.list[index].id==songController.nowPlay.value.id ? colorController.color6(): colorController.darkMode.value ? Colors.white : Colors.black,
                              fontWeight: songController.nowPlay.value.list[index].id==songController.nowPlay.value.id ? FontWeight.bold : FontWeight.normal
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}