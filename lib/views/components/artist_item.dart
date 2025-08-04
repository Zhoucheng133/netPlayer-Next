import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/variables.dart';

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
                      'artist'.tr,
                      style: GoogleFonts.notoSansSc(
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
  bool hover=false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        if(c.page.value!=Pages.artist){
          c.page.value=Pages.artist;
        }
        c.pageId.value=widget.id;
      },
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
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.name,
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
                  width: 100,
                  child: Center(
                    child: Text(
                      widget.albumCount==null ? "/" : widget.albumCount.toString(),
                      style: GoogleFonts.notoSansSc(
                        fontSize: 13,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}