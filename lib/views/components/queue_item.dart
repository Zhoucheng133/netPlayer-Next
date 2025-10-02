import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/operations.dart';

class QueueItem extends StatefulWidget {
  final int index;

  const QueueItem({super.key, required this.index});

  @override
  State<QueueItem> createState() => _QueueItemState();
}

class _QueueItemState extends State<QueueItem> {

  final SongController songController=Get.find();
  final ColorController colorController=Get.find();
  final Controller c=Get.find();
  final Operations operations=Operations();

  bool hover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: ()=>operations.playSong(context, songController.nowPlay.value.list[widget.index], songController.nowPlay.value.playFrom, widget.index, songController.nowPlay.value.list),
      child: AnimatedContainer(
        height: 35,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: hover ?  colorController.color2(): colorController.darkMode.value ? colorController.color3() : Colors.white,
        ),
        child: MouseRegion(
          onEnter: (_){
            setState(() {
              hover=true;
            });
          },
          onExit: (_){
            setState(() {
              hover=false;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Center(
                    child: songController.nowPlay.value.list[widget.index].id==songController.nowPlay.value.id ? Icon(
                      Icons.play_arrow_rounded,
                      color: colorController.color6(),
                      size: 15,
                    ) : Text(
                      (widget.index+1).toString(),
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
                    songController.nowPlay.value.list[widget.index].title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansSc(
                      color: songController.nowPlay.value.list[widget.index].id==songController.nowPlay.value.id ? colorController.color6(): colorController.darkMode.value ? Colors.white : Colors.black,
                      fontWeight: songController.nowPlay.value.list[widget.index].id==songController.nowPlay.value.id ? FontWeight.bold : FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}