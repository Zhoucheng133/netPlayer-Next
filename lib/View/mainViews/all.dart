// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class allView extends StatefulWidget {
  const allView({super.key});

  @override
  State<allView> createState() => _allViewState();
}

class _allViewState extends State<allView> {

  final operations=Operations();
  final Controller c = Get.put(Controller());

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              const viewHeader(title: '所有歌曲', subTitle: ''),
              const songHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.allSongs.length,
                    // TODO 注意修改参数
                    itemBuilder: (BuildContext context, int index){
                      return Obx(() => songItem(
                          index: index, 
                          title: c.allSongs[index]['title'], 
                          duration: c.allSongs[index]['duration'], 
                          id: c.allSongs[index]['id'], 
                          isplay: isPlay(index), 
                          artist: c.allSongs[index]['artist'], 
                          from: 'all',
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