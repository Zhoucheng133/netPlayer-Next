// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class lovedView extends StatefulWidget {
  const lovedView({super.key});

  @override
  State<lovedView> createState() => _lovedViewState();
}

class _lovedViewState extends State<lovedView> {

  final operations=Operations();
  final Controller c = Get.put(Controller());
  final controller=AutoScrollController();
  TextEditingController inputController = TextEditingController();
  String searchKeyWord='';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getLovedSongs(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
  }

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='loved'){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(c.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
  }

  Future<void> refresh() async {
    await operations.checkLovedSongPlay(context);
    showMessage(true, '更新成功', context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>viewHeader(title: '喜欢的歌曲', subTitle: '共有${c.lovedSongs.length}首', page: 'loved', locate: ()=>locateSong(), refresh: ()=>refresh(), controller: inputController,)),
              const songHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    controller: controller,
                    itemCount: c.lovedSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: searchKeyWord.isEmpty ? Obx(()=>
                          songItem(
                            index: index, 
                            title: c.lovedSongs[index]['title'], 
                            duration: c.lovedSongs[index]['duration'], 
                            id: c.lovedSongs[index]['id'], 
                            isplay: isPlay(index),
                            artist: c.lovedSongs[index]['artist'], 
                            from: 'loved',
                            album: c.lovedSongs[index]['album'],
                            artistId: c.lovedSongs[index]['artistId'], 
                            albumId: c.lovedSongs[index]['albumId'],
                          )
                        ) : Obx(()=>
                          c.lovedSongs[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) ||  c.lovedSongs[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          songItem(
                            index: index, 
                            title: c.lovedSongs[index]['title'], 
                            duration: c.lovedSongs[index]['duration'], 
                            id: c.lovedSongs[index]['id'], 
                            isplay: isPlay(index), 
                            artist: c.lovedSongs[index]['artist'], 
                            from: 'loved',
                            album: c.lovedSongs[index]['album'], 
                            artistId: c.lovedSongs[index]['artistId'], 
                            albumId: c.lovedSongs[index]['albumId'],
                          ) : Container()
                        )
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