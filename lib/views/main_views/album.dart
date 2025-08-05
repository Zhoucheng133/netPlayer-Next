import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/album_item.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class AlbumView extends StatefulWidget {
  const AlbumView({super.key});

  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {

  final Controller c = Get.find();
  TextEditingController inputController = TextEditingController();
  final SongController songController=Get.find();
  String searchKeyWord='';
  late Worker listener;
  String albumName='';
  String id='';
  List list=[];
  final operations=Operations();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getAlbums(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
    listener = ever(c.pageId, (String albumId) async {
      if(c.page.value==Pages.album && c.pageId.value!=''){
        Map rlt=await operations.getAlbumData(context, albumId);
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

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  void refresh(BuildContext context){
    operations.getAlbums(context);
    showMessage(true, '更新成功', context);
  }
  bool isPlay(int index){
     if(index==songController.nowPlay.value.index && songController.nowPlay.value.playFrom==Pages.album && songController.nowPlay.value.fromId==id){
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
                c.pageId.value=='' ? ViewHeader(title: 'albums'.tr, subTitle: 'total'.tr+c.albums.length.toString()+'albumTotal'.tr, page: Pages.album, refresh: ()=>refresh(context), controller: inputController,) :
                ViewHeader(title: '${"album".tr}: $albumName', subTitle: 'total'.tr+list.length.toString()+'songTotal'.tr, page: Pages.album, refresh: ()=>(){},)
              ),
              // const albumHeader(),
              Obx(()=>
                c.pageId.value=='' ? const AlbumHeader() : const SongHeader()
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
                        AlbumItem(
                          id: c.albums[index]['id'], 
                          title: c.albums[index]['title'], 
                          artist: c.albums[index]['artist'], 
                          songCount: c.albums[index]['songCount'], 
                          index: index, 
                          clearSearch: () {}, 
                          artistId: c.albums[index]['artistId'],
                        )
                      ) : Obx(()=>
                        c.albums[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || c.albums[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        AlbumItem(
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
                          artistId: c.albums[index]['artistId'],
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
                          SongItem(
                            index: index, 
                            title: list[index]['title'], 
                            duration: list[index]['duration'], 
                            id: list[index]['id'], 
                            isplay: isPlay(index), 
                            artist: list[index]['artist'], 
                            from: Pages.album, 
                            listId: id, 
                            list: list, 
                            album: list[index]['album'], 
                            artistId: list[index]['artistId']??'', 
                            albumId: list[index]['albumId']??'', 
                            created: list[index]['created']??'',
                          )
                        ) : list[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        Obx(()=>
                          SongItem(
                            index: index, 
                            title: list[index]['title'], 
                            duration: list[index]['duration'], 
                            id: list[index]['id'], 
                            isplay: isPlay(index), 
                            artist: list[index]['artist'], 
                            from: Pages.album, 
                            listId: id, 
                            list: list,
                            album: list[index]['album'], 
                            artistId: list[index]['artistId']??'', 
                            albumId: list[index]['albumId']??'',
                            created: list[index]['created']??'',
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