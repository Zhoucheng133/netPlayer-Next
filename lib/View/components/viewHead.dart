// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class viewHeader extends StatefulWidget {

  final String title;
  final String subTitle;
  final String page;
  final dynamic id;
  final dynamic locate;
  final dynamic refresh;
  final dynamic controller;
  const viewHeader({super.key, required this.title, required this.subTitle, required this.page, this.id, this.locate, this.refresh, this.controller});

  @override
  State<viewHeader> createState() => _viewHeaderState();
}

class _viewHeaderState extends State<viewHeader> {
  
  final Controller c = Get.put(Controller());
  bool hoverLocate=false;
  bool hoverRefresh=false;
  bool hoverRandom=false;
  bool hasFocus=false;
  FocusNode focusOnSearch=FocusNode();

  @override
  void initState() {
    super.initState();
    focusOnSearch.addListener((){
      if(focusOnSearch.hasFocus){
        setState(() {
          hasFocus=true;
        });
      }else{
        setState(() {
          hasFocus=false;
        });
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
                Text(
                  widget.title,
                  style: TextStyle(
                    color: c.color5,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  widget.subTitle,
                  style: TextStyle(
                    color: c.color5,
                    fontSize: 13
                  ),
                ),
                const SizedBox(width: 10,),
                widget.page=='all' ? GestureDetector(
                  onTap: (){
                    Operations().fullRandomPlaySwitcher(context);
                  },
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
                    style: const TextStyle(
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
            )
          ):Container(),
          const SizedBox(width: 10,),
          widget.page=='playList' || widget.page=='all' || widget.page=='loved' ? 
          GestureDetector(
            onTap: (){
              widget.refresh();
            },
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
          ) : Container()
        ],
      ),
    );
  }
}