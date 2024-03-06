// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../paras/paras.dart';

class lyricView extends StatefulWidget {
  const lyricView({super.key});

  @override
  State<lyricView> createState() => _lyricViewState();
}

class _lyricViewState extends State<lyricView> {
  
  final Controller c = Get.put(Controller());

  AutoScrollController controller = AutoScrollController();

  bool playedLyric(index){
    if(c.lyric.length==1){
      return true;
    }
    bool flag=false;
    try {
      flag=c.playProgress>=c.lyric[index]['time'] && c.playProgress<c.lyric[index+1]['time'];
    } catch (e) {
      flag=false;
    }
    return flag;
  }

  Timer? _debounce;

  void scrollLyric(){
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 5), () {
      controller.scrollToIndex(c.lyricLine.value-1, preferPosition: AutoScrollPosition.middle);
    });
  }

  @override
  void initState() {
    super.initState();
    ever(c.lyricLine, (callback) {
      if(c.lyricLine.value==0 && controller.hasClients){
        controller.animateTo(
          0,
          duration: Duration(milliseconds: 300), 
          curve: Curves.easeInOut
        );
      }else{
        scrollLyric();
      }
      
    });
    
    ever(c.showLyric, (callback){
      if(c.showLyric.value==true){
        if(c.lyricLine.value==0 && controller.hasClients){
          controller.animateTo(
            0,
            duration: Duration(milliseconds: 300), 
            curve: Curves.easeInOut
          );
        }else{
          scrollLyric();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 130),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Obx(() => 
            ListView.builder(
              controller: controller,
              itemCount: c.lyric.length,
              itemBuilder: (BuildContext context, int index) => 
              Column(
                children: [
                  index==0 ? SizedBox(height: (MediaQuery.of(context).size.height-60-25-130-18)/2,) : Container(),
                  Obx(() => 
                    AutoScrollTag(
                      key: ValueKey(index), 
                      controller: controller, 
                      index: index,
                      child: Text(
                        c.lyric[index]['content'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          height: 2.3,
                          color: playedLyric(index) ? Colors.blue:Colors.grey[350],
                          fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                        ),
                      ),
                    )
                  ),
                  index==c.lyric.length-1 ? SizedBox(height: (MediaQuery.of(context).size.height-60-25-130-18)/2,) : Container(),
                ],
              )
            ),
          ),
        )
      ),
    );
  }
}