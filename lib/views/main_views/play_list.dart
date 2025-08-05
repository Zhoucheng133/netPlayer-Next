import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({super.key});

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  
  final Controller c = Get.find();
  final operations=Operations();
  final AutoScrollController controller=AutoScrollController();
  final SongController songController=Get.find();
  List<SongItemClass> list=[];
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
    if(c.page.value==Pages.playList){
      setState(() {
        name=c.playLists.firstWhere((item)=>item['id']==newId)['name'];
        listId=newId;
      });
      var temp=await operations.getPlayList(context, newId);
      setState(() {
        list=temp.map((item)=>SongItemClass.fromJson(item)).toList();
      });
    }
  }

  String name='';

  bool isPlay(int index){
    if(index==songController.nowPlay.value.index && songController.nowPlay.value.playFrom==Pages.playList && songController.nowPlay.value.fromId==listId){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(songController.nowPlay.value.index, preferPosition: AutoScrollPosition.middle);
  }

  Future<void> silentRefresh() async {
    var tmpList=await operations.getPlayList(context, listId);
    setState(() {
      list=tmpList.map((item)=>SongItemClass.fromJson(item)).toList();
    });
    if(songController.nowPlay.value.playFrom==Pages.playList && songController.nowPlay.value.fromId==listId){
      int index=list.indexWhere((item) => item.id==songController.nowPlay.value.id);
      if(index!=-1){
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=list;
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
  }

  Future<void> refresh(BuildContext context) async {
    var tmpList=await operations.getPlayList(context, listId);
    setState(() {
      list=tmpList.map((item)=>SongItemClass.fromJson(item)).toList();
    });
    if(songController.nowPlay.value.playFrom==Pages.playList && songController.nowPlay.value.fromId==listId){
      int index=list.indexWhere((item) => item.id==songController.nowPlay.value.id);
      if(index!=-1){
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=list;
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
    if(context.mounted) showMessage(true, 'updateOk'.tr, context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>ViewHeader(title: name, subTitle: 'total'.tr+list.length.toString()+'songTotal'.tr, page: Pages.playList, id: c.pageId.value, locate: locateSong, refresh: ()=>refresh(context), controller: inputController,),),
              const SongHeader(),
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
                        SongItem(
                          index: index, 
                          title: list[index].title, 
                          duration: list[index].duration, 
                          id: list[index].id, 
                          isplay: isPlay(index), 
                          artist: list[index].artist, 
                          from: Pages.playList, 
                          listId: listId, 
                          list: list, 
                          refresh: ()=>silentRefresh(),
                          album: list[index].album, 
                          artistId: list[index].artistId, 
                          albumId: list[index].albumId,
                          created: list[index].created,
                        ),
                      ): list[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                      Obx(()=>SongItem(
                        index: index, 
                        title: list[index].title, 
                        duration: list[index].duration, 
                        id: list[index].id, 
                        isplay: isPlay(index), 
                        artist: list[index].artist, 
                        from: Pages.playList, 
                        listId: listId, 
                        list: list, 
                        refresh: ()=>silentRefresh(),
                        album: list[index].album, 
                        artistId: list[index].artistId, 
                        albumId: list[index].albumId,
                        created: list[index].created,
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