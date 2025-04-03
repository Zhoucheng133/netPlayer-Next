// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:url_launcher/url_launcher.dart';

// 歌曲表头
class SongHeader extends StatefulWidget {
  const SongHeader({super.key});

  @override
  State<SongHeader> createState() => _SongHeaderState();
}

class _SongHeaderState extends State<SongHeader> {

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'songTitle'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'artist'.tr,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Center(
                    child: Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
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
                    padding: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.only(left: 10),
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

// 专辑表头
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
                    padding: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.only(left: 10),
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
                    padding: EdgeInsets.only(left: 10),
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

// 歌曲Item
class SongItem extends StatefulWidget {
  final int index;
  final String title;
  final int duration;
  final String id;
  final bool isplay;
  final String artist;
  final dynamic listId;
  final String album;
  final String from;
  final dynamic list;
  final dynamic refresh;
  final String artistId;
  final String albumId;
  const SongItem({super.key, required this.index, required this.title, required this.duration, required this.isplay, required this.artist, required this.id, this.listId, required this.from, this.list, this.refresh, required this.album, required this.artistId, required this.albumId});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  
  bool hover=false;
  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  final operations=Operations();

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool isLoved(){
    for (var val in c.lovedSongs) {
      if(val["id"]==widget.id){
        return true;
      }
    }
    return false;
  }

  Future<void> showSongMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      context: context, 
      color: colorController.darkMode.value ? colorController.color3() : Colors.white,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        PopupMenuItem(
          value: "add",
          enabled: c.playLists.isNotEmpty,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "addToList".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        isLoved() ? PopupMenuItem(
          value: "delove",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.heart_broken_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "delove".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ) : PopupMenuItem(
          value: "love",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "love".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: "album",
          height: 35,
          enabled: widget.albumId.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.album_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "showAlbum".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: "artist",
          height: 35,
          enabled: widget.artistId.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.mic_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
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
          value: "del",
          height: 35,
          enabled: widget.listId!=null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_remove_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "removeFromList".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: "download",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.download_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              SizedBox(width: 5,),
              Text(
                "download".tr,
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
              SizedBox(width: 5,),
              Text(
                "songInfo".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        )
      ]
    );
    if(val=='add'){
      String selectItem = c.playLists[0]["id"];
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('addToList'.tr),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return SizedBox(
                height: 200,
                width: 300,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.playLists.length,
                    itemBuilder: (BuildContext context, int index){
                      return SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Obx(()=>
                              Radio(
                                value: c.playLists[index]["id"], 
                                activeColor: colorController.color6(),
                                groupValue: selectItem, 
                                onChanged: (val){
                                  setState(()=>
                                    selectItem=val
                                  );
                                }
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectItem=c.playLists[index]["id"];
                                });
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  c.playLists[index]["name"]
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  )
                ),
              );
            }
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
                operations.addToList(context, widget.id, selectItem);
                Navigator.pop(context);
              }, 
              child: Text('add'.tr)
            )
          ],
        )
      );
    }else if(val=='delove'){
      operations.deloveSong(context, widget.id);
    }else if(val=='love'){
      operations.loveSong(context, widget.id);
    }else if(val=='del'){
      if(await operations.delFromList(context, widget.listId, widget.index)){
        widget.refresh();
      }
    }else if(val=='album'){
      c.pageIndex.value=3;
      c.pageId.value=widget.albumId;
    }else if(val=='artist'){
      c.pageIndex.value=2;
      c.pageId.value=widget.artistId;
    }else if(val=='download'){
      final Uri url = Uri.parse('${c.userInfo['url']}/rest/download?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${widget.id}');
      await launchUrl(url);
    }else if(val=="info"){
      operations.songInfo(context, {
        "title": widget.title,
        "duration": convertDuration(widget.duration),
        "id": widget.id,
        "artist": widget.artist,
        "listId": widget.listId,
        "album": widget.album,
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        operations.playSong(context, widget.id, widget.title, widget.artist, widget.from, widget.duration, widget.listId??'', widget.index, widget.list??[], widget.album);
      },
      onSecondaryTapDown: (val) => showSongMenu(context, val),
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
            color: hover ?  colorController.color1(): colorController.darkMode.value ? colorController.color2() : Colors.white,
            height: 40,
            width: MediaQuery.of(context).size.width - 200,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: widget.isplay ? Icon(
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.title,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                          color: widget.isplay ? colorController.color6(): colorController.darkMode.value ? Colors.white : Colors.black,
                          fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal,
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
                        widget.artist,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                          color: widget.isplay ? colorController.color6(): colorController.darkMode.value ? Colors.white : Colors.black,
                          fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal
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
                        convertDuration(widget.duration),
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                          color: widget.isplay ? colorController.color6(): colorController.darkMode.value ? Colors.white : Colors.black,
                          fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal
                        ),
                      )
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
                ],
              ),
          ),
        ),
      ),
    );
  }
}

// 专辑Item
class AlbumItem extends StatefulWidget {
  final int index;
  final String id;
  final String title;
  final String artist;
  final int songCount;
  final VoidCallback clearSearch;
  const AlbumItem({super.key, required this.id, required this.title, required this.artist, required this.songCount, required this.index, required this.clearSearch});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  
  bool hover=false;
  final Controller c = Get.find();
  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        if(c.pageIndex.value!=3){
          c.pageIndex.value=3;
        }
        c.pageId.value=widget.id;
        widget.clearSearch();
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
                    )
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.title,
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
                      widget.artist,
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
                      widget.songCount.toString(),
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

class ArtistItem extends StatefulWidget {
  final int index;
  final String id;
  final String name;
  final int albumCount;
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
        if(c.pageIndex.value!=2){
          c.pageIndex.value=2;
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
                      widget.albumCount.toString(),
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