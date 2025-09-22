import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/album_item.dart';
import 'package:net_player_next/views/components/album_skeleton.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/song_skeleton.dart';
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
  List<SongItemClass> list=[];
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
        setState(() {
          albumName="";
        });
        final start = DateTime.now();
        c.loading.value=true;
        Map rlt=await operations.getAlbumData(context, albumId);
        if(rlt.isNotEmpty){
          try {
            setState(() {
              albumName=rlt['name'];
              final List songs=rlt['song'];
              list=songs.map((item)=>SongItemClass.fromJson(item)).toList();
              for (var item in list) {
                item.fromId=rlt['id'];
              }
              id=rlt['id'];
            });
          } catch (_) {}
        }
        final elapsed = DateTime.now().difference(start);
        const minDuration = Duration(milliseconds: 200);
        if (elapsed < minDuration) {
          await Future.delayed(minDuration - elapsed);
        }
        c.loading.value=false;
      }
    });
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  Future<void> refresh(BuildContext context) async {
    final start = DateTime.now();
    c.loading.value=true;
    await operations.getAlbums(context);
    final elapsed = DateTime.now().difference(start);
    const minDuration = Duration(milliseconds: 200);
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
    c.loading.value=false;
    if(context.mounted) showMessage(true, '更新成功', context);
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
                    c.loading.value ? const AlbumSkeleton() : ListView.builder(
                      itemCount: c.albums.length,
                      itemBuilder: (BuildContext context, int index)=> searchKeyWord.isEmpty ? Obx(()=>
                        AlbumItem(
                          data: c.albums[index], 
                          index: index, 
                          clearSearch: () {}, 
                        )
                      ) : Obx(()=>
                        c.albums[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) || c.albums[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        AlbumItem(
                          data: c.albums[index], 
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
                ) : 
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  height: MediaQuery.of(context).size.height - 222,
                  child: Obx(()=>
                    c.loading.value ? SongSkeleton(count: c.childCount.value,) : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index){
                        return searchKeyWord.isEmpty ? Obx(()=>
                          SongItem(
                            index: index, 
                            isplay: isPlay(index), 
                            from: Pages.album, 
                            list: list, 
                            song: list[index],
                          )
                        ) : list[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        Obx(()=>
                          SongItem(
                            index: index, 
                            song: list[index],
                            isplay: isPlay(index), 
                            from: Pages.album, 
                            list: list,
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