import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class ViewHeader extends StatefulWidget {

  final String title;
  final String subTitle;
  final String page;
  final dynamic id;
  final dynamic locate;
  final dynamic refresh;
  final dynamic controller;
  const ViewHeader({super.key, required this.title, required this.subTitle, required this.page, this.id, this.locate, this.refresh, this.controller});

  @override
  State<ViewHeader> createState() => _ViewHeaderState();
}

class _ViewHeaderState extends State<ViewHeader> {
  
  final Controller c = Get.put(Controller());
  bool hoverLocate=false;
  bool hoverRefresh=false;
  bool hoverRandom=false;
  bool hasFocus=false;
  bool hoverBack=false;
  bool hoverWarning=false;
  FocusNode focusOnSearch=FocusNode();

  @override
  void initState() {
    super.initState();
    focusOnSearch.addListener((){
      if(focusOnSearch.hasFocus){
        setState(() {
          hasFocus=true;
        });
        c.onInput.value=true;
      }else{
        setState(() {
          hasFocus=false;
        });
        c.onInput.value=false;
      }
    });
  }

  @override
  void dispose() {
    focusOnSearch.dispose();
    super.dispose();
  }
  bool hasBackButton(){
    if(c.pageId.value.isNotEmpty && (c.pageIndex.value==2 || c.pageIndex.value==3)){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: 30,
      child: Row(
        children: [
          // c.pageId.value.isNotEmpty ? Icon(Icons.arrow_back_rounded):Container(),
          hasBackButton()?Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){
                  c.pageId.value='';
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
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
                  child: TweenAnimationBuilder(
                    tween: ColorTween(end: hoverBack ? c.color6 : c.color5), 
                    duration: const Duration(milliseconds: 200), 
                    builder: (_, value, __)=>Icon(
                      Icons.arrow_back_rounded,
                      color: value,
                    )
                  ),
                ),
              ),
              const SizedBox(width: 10,),
            ],
          ) : Container(),
          Expanded(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 550,
                  ),
                  child: Text(
                    widget.title,
                    style: GoogleFonts.notoSansSc(
                      color: c.color5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  widget.subTitle,
                  style: GoogleFonts.notoSansSc(
                    color: c.color5,
                    fontSize: 13
                  ),
                ),
                c.allSongs.length>=500 && widget.page=='all' ? const SizedBox(width: 10,) : Container(),
                Obx(()=>
                  c.allSongs.length>=500 && widget.page=='all' ? 
                  Tooltip(
                    message: 'overCountTip'.tr,
                    child: MouseRegion(
                      onEnter: (_){
                        setState(() {
                          hoverWarning=true;
                        });
                      },
                      onExit: (_){
                        setState(() {
                          hoverWarning=false;
                        });
                      },
                      child: TweenAnimationBuilder(
                        tween: ColorTween(end: hoverWarning ? Colors.orange : Colors.grey[400]), 
                        duration: const Duration(milliseconds: 200), 
                        builder: (_, value, __)=>Icon(
                          Icons.warning_rounded,
                          size: 17,
                          color: value,
                        )
                      ),
                    ),
                  ) : Container()
                ),
                const SizedBox(width: 10,),
                widget.page=='all' ? GestureDetector(
                  onTap: (){
                    Operations().fullRandomPlaySwitcher(context);
                  },
                  child: Tooltip(
                    message: 'shuffleAllSongs'.tr,
                    waitDuration: const Duration(seconds: 1),
                    child: MouseRegion(
                      onEnter: (_){
                        setState(() {
                          hoverRandom=true;
                        });
                      },
                      onExit: (_){
                        setState(() {
                          hoverRandom=false;
                        });
                      },
                      cursor: SystemMouseCursors.click,
                      child: Obx(()=>
                        TweenAnimationBuilder(
                          tween: ColorTween(end: hoverRandom ? c.color6 : c.fullRandom.value ? c.color5 : Colors.grey[400]), 
                          duration: const Duration(milliseconds: 200), 
                          builder: (_, value, __)=>Icon(
                            Icons.shuffle_rounded,
                            size: 17,
                            color: value,
                          )
                        ),
                      )
                    ),
                  ),
                ) :   Container(),
              ],
            ),
          ),
          widget.page!='settings' && widget.page!='search' ?
          AnimatedContainer(
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: hasFocus ? Border.all(
                color: c.color5,
                width: 2
              ): Border.all(
                color: c.color3,
                width: 2
              )
            ),
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: TweenAnimationBuilder(
                    tween: ColorTween(end: hasFocus ? c.color5 : c.color3), 
                    duration: const Duration(milliseconds: 200),
                    builder: (_, value, __)=>Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: value,
                    ),
                  )
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: focusOnSearch,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(top: 9, bottom: 10, left: 5, right: 10),
                    ),
                    style: GoogleFonts.notoSansSc(
                      fontSize: 12
                    ),
                  ),
                ),
              ],
            ),
          ) : Container(),
          const SizedBox(width: 15,),
          widget.page=='playList' || widget.page=='all' || widget.page=='loved' ?
          GestureDetector(
            onTap: (){
              if(c.nowPlay['playFrom']==widget.page && (c.nowPlay['playFrom']!='playList' || c.nowPlay['fromId']==widget.id)){
                widget.locate();
              }
            },
            child: Tooltip(
              waitDuration: const Duration(seconds: 1),
              message: 'locate'.tr,
              child: Obx(()=>
                MouseRegion(
                  cursor: c.nowPlay['playFrom']==widget.page && (c.nowPlay['playFrom']!='playList' || c.nowPlay['fromId']==widget.id) ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
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
                    tween: ColorTween(end:  c.nowPlay['playFrom']==widget.page && (c.nowPlay['playFrom']!='playList' || c.nowPlay['fromId']==widget.id) ? hoverLocate ? c.color6 : c.color5 : Colors.grey[300]), 
                    duration: const Duration(milliseconds: 200), 
                    builder: (_, value, __) => Icon(
                      Icons.my_location_rounded,
                      size: 17,
                      color: value,
                    )
                  ),
                ),
              ),
            )
          ):Container(),
          const SizedBox(width: 10,),
          Obx(()=>
            !(c.pageId.value.isNotEmpty && (widget.page=='album' || widget.page=='artist')) && widget.page!='settings' && widget.page!='search' ? 
            GestureDetector(
              onTap: (){
                widget.refresh();
              },
              child: Tooltip(
                waitDuration: const Duration(seconds: 1),
                message: 'refresh'.tr,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_){
                    setState(() {
                      hoverRefresh=true;
                    });
                  },
                  onExit: (_){
                    setState(() {
                      hoverRefresh=false;
                    });
                  },
                  child: TweenAnimationBuilder(
                    tween: ColorTween(end: hoverRefresh ? c.color6 : c.color5),
                    duration: const Duration(milliseconds: 200), 
                    builder: (_, value, __) => Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: value,
                    ),
                  )
                ),
              ),
            ) : Container()
          )
        ],
      ),
    );
  }
}

class SearchHeader extends StatefulWidget {
  final TextEditingController controller;
  final String type;
  final ValueChanged changeType;
  final VoidCallback search;
  const SearchHeader({super.key, required this.controller, required this.type, required this.changeType, required this.search});

  @override
  State<SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<SearchHeader> {

  final Controller c = Get.put(Controller());
  bool hasFocus=false;
  bool hoverSong=false;
  bool hoverAlbum=false;
  bool hoverArtist=false;
  FocusNode focusOnSearch=FocusNode();

  @override
  void initState() {
    super.initState();
    focusOnSearch.addListener((){
      if(focusOnSearch.hasFocus){
        setState(() {
          hasFocus=true;
        });
        c.onInput.value=true;
      }else{
        setState(() {
          hasFocus=false;
        });
        c.onInput.value=false;
      }
    });
  }

  @override
  void dispose() {
    focusOnSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 550,
                  ),
                  child: Text(
                    '${'search'.tr}:',
                    style: GoogleFonts.notoSansSc(
                      color: c.color5,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    if(widget.type!='song'){
                      widget.changeType('song');
                    }
                  },
                  child: Tooltip(
                    waitDuration: const Duration(seconds: 1),
                    message: '搜索歌曲',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_){
                        setState(() {
                          hoverSong=true;
                        });
                      },
                      onExit: (_){
                        setState(() {
                          hoverSong=false;
                        });
                      },
                      child: TweenAnimationBuilder(
                        tween: ColorTween(end: widget.type=='song' ? c.color4 : hoverSong ? c.color6 : c.color3),
                        duration: const Duration(milliseconds: 200), 
                        builder: (_, value, __)=>Icon(
                          Icons.music_note_rounded,
                          color: value,
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    if(widget.type!='album'){
                      widget.changeType('album');
                    }
                  },
                  child: Tooltip(
                    waitDuration: const Duration(seconds: 1),
                    message: '搜索专辑',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_){
                        setState(() {
                          hoverAlbum=true;
                        });
                      },
                      onExit: (_){
                        setState(() {
                          hoverAlbum=false;
                        });
                      },
                      child: TweenAnimationBuilder(
                        tween: ColorTween(end: widget.type=='album' ? c.color4 : hoverAlbum ? c.color6 : c.color3),
                        duration: const Duration(milliseconds: 200), 
                        builder: (_, value, __)=>Icon(
                          Icons.album_rounded,
                          color: value,
                        )
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    if(widget.type!='artist'){
                      widget.changeType('artist');
                    }
                  },
                  child: Tooltip(
                    waitDuration: const Duration(seconds: 1),
                    message: '搜索艺人',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_){
                        setState(() {
                          hoverArtist=true;
                        });
                      },
                      onExit: (_){
                        setState(() {
                          hoverArtist=false;
                        });
                      },
                      child: TweenAnimationBuilder(
                        tween: ColorTween(end: widget.type=='artist' ? c.color4 : hoverArtist ? c.color6 : c.color3),
                        duration: const Duration(milliseconds: 200), 
                        builder: (_, value, __)=>Icon(
                          Icons.mic_rounded,
                          color: value,
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: hasFocus ? Border.all(
                color: c.color5,
                width: 2
              ): Border.all(
                color: c.color3,
                width: 2
              )
            ),
            duration: const Duration(milliseconds: 200),
            child: Row(
              children: [
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: TweenAnimationBuilder(
                    tween: ColorTween(end: hasFocus ? c.color5 : c.color3), 
                    duration: const Duration(milliseconds: 200),
                    builder: (_, value, __)=>Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: value,
                    ),
                  )
                ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: focusOnSearch,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(top: 9, bottom: 10, left: 5, right: 10),
                    ),
                    style: GoogleFonts.notoSansSc(
                      fontSize: 12
                    ),
                    onEditingComplete: (){
                      widget.search();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}