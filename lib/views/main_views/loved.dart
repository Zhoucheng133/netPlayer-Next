import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
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
  final Controller c = Get.find();
  final controller=AutoScrollController();
  final SongController songController=Get.find();
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

  Future<void> refresh(BuildContext context) async {
    await operations.checkLovedSongPlay(context);
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
              Obx(()=>ViewHeader(title: 'lovedSongs'.tr, subTitle: 'total'.tr+songController.lovedSongs.length.toString()+'songTotal'.tr, page: 'loved', locate: locateSong, refresh: ()=>refresh(context), controller: inputController,)),
              const SongHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    controller: controller,
                    itemCount: songController.lovedSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: searchKeyWord.isEmpty ? Obx(()=>
                          SongItem(
                            index: index, 
                            title: songController.lovedSongs[index].title, 
                            duration: songController.lovedSongs[index].duration, 
                            id: songController.lovedSongs[index].id, 
                            isplay: isPlay(index),
                            artist: songController.lovedSongs[index].artist, 
                            from: 'loved',
                            album: songController.lovedSongs[index].album,
                            artistId: songController.lovedSongs[index].artistId, 
                            albumId: songController.lovedSongs[index].albumId,
                            created: songController.lovedSongs[index].created,
                          )
                        ) : Obx(()=>
                          songController.lovedSongs[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) ||  songController.lovedSongs[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          SongItem(
                            index: index, 
                            title: songController.lovedSongs[index].title, 
                            duration: songController.lovedSongs[index].duration, 
                            id: songController.lovedSongs[index].id, 
                            isplay: isPlay(index), 
                            artist: songController.lovedSongs[index].artist, 
                            from: 'loved',
                            album: songController.lovedSongs[index].album, 
                            artistId: songController.lovedSongs[index].artistId, 
                            albumId: songController.lovedSongs[index].albumId,
                            created: songController.lovedSongs[index].created,
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