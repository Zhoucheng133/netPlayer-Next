// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class allView extends StatefulWidget {
  const allView({super.key});

  @override
  State<allView> createState() => _allViewState();
}

class _allViewState extends State<allView> {

  final operations=Operations();
  final Controller c = Get.put(Controller());
  final AutoScrollController controller=AutoScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getAllSongs(context);
    });
  }

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='all'){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(c.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
  }

  void refresh(){
    // TODO 刷新所有歌曲
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(() => viewHeader(title: '所有歌曲', subTitle: '共有${c.allSongs.length}首', page: 'all', locate: ()=>locateSong(), refresh: ()=>refresh(),),),
              const songHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    controller: controller,
                    itemCount: c.allSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: Obx(() => songItem(
                            index: index, 
                            title: c.allSongs[index]['title'], 
                            duration: c.allSongs[index]['duration'], 
                            id: c.allSongs[index]['id'], 
                            isplay: isPlay(index), 
                            artist: c.allSongs[index]['artist'], 
                            from: 'all',
                          )
                        ),
                      );
                    }
                  )
                ),
              )
            ],
          )
        ],
      )
    );
  }
}