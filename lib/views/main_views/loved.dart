// use_build_context_synchronously

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/table.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class LovedView extends StatefulWidget {
  const LovedView({super.key});

  @override
  State<LovedView> createState() => _LovedViewState();
}

class _LovedViewState extends State<LovedView> {

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
    showMessage(true, 'updateOk'.tr, context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>ViewHeader(title: 'lovedSongs'.tr, subTitle: 'total'.tr+c.lovedSongs.length.toString()+'songTotal'.tr, page: 'loved', locate: ()=>locateSong(), refresh: ()=>refresh(), controller: inputController,)),
              const SongHeader(),
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
                          SongItem(
                            index: index, 
                            title: c.lovedSongs[index]['title'], 
                            duration: c.lovedSongs[index]['duration'], 
                            id: c.lovedSongs[index]['id'], 
                            isplay: isPlay(index),
                            artist: c.lovedSongs[index]['artist'], 
                            from: 'loved',
                            album: c.lovedSongs[index]['album'],
                            artistId: c.lovedSongs[index]['artistId']??'', 
                            albumId: c.lovedSongs[index]['albumId']??'',
                          )
                        ) : Obx(()=>
                          c.lovedSongs[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) ||  c.lovedSongs[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          SongItem(
                            index: index, 
                            title: c.lovedSongs[index]['title'], 
                            duration: c.lovedSongs[index]['duration'], 
                            id: c.lovedSongs[index]['id'], 
                            isplay: isPlay(index), 
                            artist: c.lovedSongs[index]['artist'], 
                            from: 'loved',
                            album: c.lovedSongs[index]['album'], 
                            artistId: c.lovedSongs[index]['artistId']??'', 
                            albumId: c.lovedSongs[index]['albumId']??'',
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