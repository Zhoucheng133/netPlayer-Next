// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {
  
  final Controller c = Get.put(Controller());
  final AutoScrollController controller=AutoScrollController();
  List list=[];
  String listId='';

  @override
  void initState() {
    super.initState();
    ever(c.pageId, (newVal)=>pageIdListener(newVal));
  }

  Future<void> pageIdListener(String newId) async {
    if(c.pageIndex.value==4){
      setState(() {
        name=c.playLists.firstWhere((item)=>item['id']==newId)['name'];
        listId=newId;
      });
      var temp=await Operations().getPlayList(context, newId);
      setState(() {
        list=temp;
      });
    }
  }

  String name='';

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='playList' && c.nowPlay['fromId']==listId){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(c.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>viewHeader(title: name, subTitle: '共有${list.length}首', page: 'playList', id: c.pageId.value, locate: ()=>locateSong(),),),
              const songHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: ListView.builder(
                  controller: controller,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index){
                    return AutoScrollTag(
                      key: ValueKey(index), 
                      controller: controller, 
                      index: index,
                      child: Obx(()=>songItem(index: index, title: list[index]['title'], duration: list[index]['duration'], id: list[index]['id'], isplay: isPlay(index), artist: list[index]['artist'], from: 'playList', listId: listId,),)
                    );
                  }
                ),
              )
            ],
          )
        ],
      )
    );
  }
}