// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class lovedView extends StatefulWidget {
  const lovedView({super.key});

  @override
  State<lovedView> createState() => _lovedViewState();
}

class _lovedViewState extends State<lovedView> {

  final operations=Operations();
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getLovedSongs(context);
    });
  }

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='loved'){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>viewHeader(title: '喜欢的歌曲', subTitle: '共有${c.lovedSongs.length}首', page: 'loved',)),
              const songHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.lovedSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return Obx(()=>
                        songItem(index: index, title: c.lovedSongs[index]['title'], duration: c.lovedSongs[index]['duration'], id: c.lovedSongs[index]['id'], isplay: isPlay(index), artist: c.lovedSongs[index]['artist'], from: 'loved',)
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