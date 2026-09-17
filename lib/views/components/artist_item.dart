import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/operations.dart';

// 艺人表头
class ArtistHeader extends StatefulWidget {
  const ArtistHeader({super.key});

  @override
  State<ArtistHeader> createState() => _ArtistHeaderState();
}

class _ArtistHeaderState extends State<ArtistHeader> {

  final Controller c = Get.find();
  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: 35,
          child: Obx(()=>
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'no.'.tr,
                      style: TextStyle(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'artist'.tr,
                      style: TextStyle(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      'albumCount'.tr,
                      style: TextStyle(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    )
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(()=>
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: colorController.color4(),
              borderRadius: BorderRadius.circular(2)
            ),
          ),
        )
      ],
    );
  }
}

class ArtistItem extends StatefulWidget {
  final int index;
  final String id;
  final String name;
  final int? albumCount;
  const ArtistItem({super.key, required this.id, required this.name, required this.albumCount, required this.index});

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {

  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  final SongController songController=Get.find();
  final Operations operations=Operations();
  bool hover=false;

  bool isLoved(){
    for (var val in songController.lovedArtists) {
      if(val['id']==widget.id){
        return true;
      }
    }
    return false;
  }

  Future<void> showArtistMenu(BuildContext context, TapDownDetails details) async {
    final tapPosition = details.globalPosition;
    var val=await showMenu(
      color: colorController.darkMode.value ? colorController.color3() : Colors.white,
      context: context, 
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx,
        tapPosition.dy,
      ),
      items: [
        PopupMenuItem(
          value: isLoved() ? "delove" : "love",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isLoved() ? Icons.heart_broken_rounded : Icons.favorite_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                isLoved() ? "delove".tr : "love".tr,
                style: TextStyle(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ]
    );

    if(val=='delove'){
      if(context.mounted) operations.deloveSong(context, widget.id);
    }else if(val=='love'){
      if(context.mounted) operations.loveSong(context, widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        c.childCount.value=widget.albumCount??0;
        if(c.page.value!=Pages.artist){
          c.page.value=Pages.artist;
        }
        c.pageId.value=widget.id;
      },
      onSecondaryTapDown: (val) => showArtistMenu(context, val),
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
        child: Obx(()=>
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: hover ? colorController.color1() : colorController.darkMode.value ? colorController.color2() : Colors.white,
            height: 40,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      (widget.index+1).toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  )
                ),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Text(
                      widget.albumCount==null ? "/" : widget.albumCount.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: isLoved() ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 16,
                    ) : Container(),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}