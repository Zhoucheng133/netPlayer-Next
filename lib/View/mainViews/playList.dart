// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
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
  TextEditingController inputController = TextEditingController();
  String searchKeyWord='';
  late Worker listener;

  @override
  void initState() {
    super.initState();
    listener=ever(c.pageId, (newVal)=>pageIdListener(newVal));
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
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

  Future<void> silentRefresh() async {
    var tmpList=await Operations().getPlayList(context, listId);
    setState(() {
      list=tmpList;
    });
    if(c.nowPlay['playFrom']=='playList' && c.nowPlay['fromId']==listId){
      int index=list.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        c.nowPlay['index']=index;
        c.nowPlay['list']=list;
        c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'album': '',
          'index': 0,
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
  }

  Future<void> refresh() async {
    var tmpList=await Operations().getPlayList(context, listId);
    setState(() {
      list=tmpList;
    });
    if(c.nowPlay['playFrom']=='playList' && c.nowPlay['fromId']==listId){
      int index=list.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        c.nowPlay['index']=index;
        c.nowPlay['list']=list;
        c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'album': '',
          'index': 0,
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
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
              Obx(()=>viewHeader(title: name, subTitle: '共有${list.length}首', page: 'playList', id: c.pageId.value, locate: ()=>locateSong(), refresh: ()=>refresh(), controller: inputController,),),
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
                      child: searchKeyWord.isEmpty ? Obx(()=>
                        songItem(
                          index: index, 
                          title: list[index]['title'], 
                          duration: list[index]['duration'], 
                          id: list[index]['id'], 
                          isplay: isPlay(index), 
                          artist: list[index]['artist'], 
                          from: 'playList', 
                          listId: listId, 
                          list: list, 
                          refresh: ()=>silentRefresh(),
                          album: list[index]['album'],
                        ),
                      ): list[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                      Obx(()=>songItem(
                        index: index, 
                        title: list[index]['title'], 
                        duration: list[index]['duration'], 
                        id: list[index]['id'], 
                        isplay: isPlay(index), 
                        artist: list[index]['artist'], 
                        from: 'playList', 
                        listId: listId, 
                        list: list, 
                        refresh: ()=>silentRefresh(),
                        album: list[index]['album'],
                      )) : Container()
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