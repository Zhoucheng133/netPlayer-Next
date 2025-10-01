import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';

class PlayQueue extends StatefulWidget {
  const PlayQueue({super.key});

  @override
  State<PlayQueue> createState() => _PlayQueueState();
}

class _PlayQueueState extends State<PlayQueue> {

  final SongController songController=Get.find();
  final ColorController colorController=Get.find();
  final Controller c=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> c.fullRandom.value ? Center(
        child: Text('queueNotAvaliable'.tr),
      ) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: songController.nowPlay.value.list.length,
                itemBuilder: (item, index)=>SizedBox(
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
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}