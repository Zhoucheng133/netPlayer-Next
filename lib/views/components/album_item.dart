import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/album_controller.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/infos.dart';

class AlbumHeader extends StatefulWidget {
  const AlbumHeader({super.key});

  @override
  State<AlbumHeader> createState() => _AlbumHeaderState();
}

class _AlbumHeaderState extends State<AlbumHeader> {

  final Controller c = Get.find();
  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width - 200,
          child: Obx(()=>
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'no.'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'albumTitle'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'artist'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    )
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Center(
                    child: Text(
                      'songCount'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        ),
        Obx(()=>
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width - 200,
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

// 专辑Item
class AlbumItem extends StatefulWidget {
  final int index;
  final AlbumItemClass data;
  final VoidCallback clearSearch;
  const AlbumItem({super.key,  required this.data, required this.index, required this.clearSearch});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  
  bool hover=false;
  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  final Infos infos=Infos();

  Future<void> showAlbumMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      color: colorController.darkMode.value ? colorController.color3() : Colors.white,
      context: context, 
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        PopupMenuItem(
          value: "artist",
          enabled: widget.data.artistId.isNotEmpty,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.mic_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                "showArtist".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: "info",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                "albumInfo".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        )
      ]
    );

    if(val=='artist'){
      c.page.value=Pages.artist;
      c.pageId.value=widget.data.artistId;
    }else if(val=='info' && context.mounted){
      infos.albumInfo(context, widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        c.childCount.value=widget.data.songCount;
        if(c.page.value!=Pages.album){
          c.page.value=Pages.album;
        }
        c.pageId.value=widget.data.id;
        widget.clearSearch();
      },
      onSecondaryTapDown: (val) => showAlbumMenu(context, val),
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
            width: MediaQuery.of(context).size.width - 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      (widget.index+1).toString(),
                      style: GoogleFonts.notoSansSc(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    )
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.data.title,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  )
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.data.artist,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Center(
                    child: Text(
                      widget.data.songCount.toString(),
                      style: GoogleFonts.notoSansSc(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}