// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class albumView extends StatefulWidget {
  const albumView({super.key});

  @override
  State<albumView> createState() => _albumViewState();
}

class _albumViewState extends State<albumView> {

  final Controller c = Get.put(Controller());
  TextEditingController inputController = TextEditingController();
  String searchKeyWord='';
  late Worker listener;
  String albumName='';
  String id='';
  List list=[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Operations().getAlbums(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
    listener = ever(c.pageId, (String albumId) async {
      if(c.pageIndex.value==3 && c.pageId.value!=''){
        Map rlt=await Operations().getAlbumData(context, albumId);
        if(rlt.isNotEmpty){
          try {
            setState(() {
              albumName=rlt['name'];
              list=rlt['song'];
              id=rlt['id'];
            });
          } catch (_) {}
        }
      }
    });
  }
  void refresh(BuildContext context){
    Operations().getAlbums(context);
    showMessage(true, '更新成功', context);
  }
  bool isPlay(int index){
     if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='album' && c.nowPlay['fromId']==id){
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
              Obx(() => 
                c.pageId.value=='' ? viewHeader(title: '专辑', subTitle: '共有${c.albums.length}个专辑', page: 'album', refresh: ()=>refresh(context), controller: inputController,) :
                viewHeader(title: '专辑: $albumName', subTitle: '共有${list.length}首', page: 'album', refresh: ()=>(){},)
              ),
              // const albumHeader(),
              Obx(()=>
                c.pageId.value=='' ? const albumHeader() : const songHeader()
              ),
              Obx(()=>
                c.pageId.value=='' ?
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  height: MediaQuery.of(context).size.height - 222,
                  child: Obx(()=>
                    ListView.builder(
                      itemCount: c.albums.length,
                      itemBuilder: (BuildContext context, int index)=> searchKeyWord.isEmpty ? Obx(()=>
                        albumItem(
                          id: c.albums[index]['id'], 
                          title: c.albums[index]['title'], 
                          artist: c.albums[index]['artist'], 
                          songCount: c.albums[index]['songCount'], 
                          index: index, 
                          clearSearch: () {}
                        )
                      ) : Obx(()=>
                        c.albums[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || c.albums[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        albumItem(
                          id: c.albums[index]['id'], 
                          title: c.albums[index]['title'], 
                          artist: c.albums[index]['artist'], 
                          songCount: c.albums[index]['songCount'], 
                          index: index,
                          clearSearch: () {
                            setState(() {
                              inputController.text='';
                            });
                          },
                        ) : Container()
                      )
                    )
                  ),
                ) : SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  height: MediaQuery.of(context).size.height - 222,
                  child: Obx(()=>
                    ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        return searchKeyWord.isEmpty ? Obx(()=>
                          songItem(
                            index: index, 
                            title: list[index]['title'], 
                            duration: list[index]['duration'], 
                            id: list[index]['id'], 
                            isplay: isPlay(index), 
                            artist: list[index]['artist'], 
                            from: 'album', 
                            listId: id, 
                            list: list, 
                            album: list[index]['album'], 
                            artistId: list[index]['artistId'], 
                            albumId: list[index]['albumId'],
                          )
                        ) : list[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        Obx(()=>
                          songItem(
                            index: index, 
                            title: list[index]['title'], 
                            duration: list[index]['duration'], 
                            id: list[index]['id'], 
                            isplay: isPlay(index), 
                            artist: list[index]['artist'], 
                            from: 'album', 
                            listId: id, 
                            list: list,
                            album: list[index]['album'], 
                            artistId: list[index]['artistId'], 
                            albumId: list[index]['albumId'],
                          )
                        ): Container();
                      }
                    ),
                  ),
                )
              )
            ],
          )
        ],
      )
    );
  }
}