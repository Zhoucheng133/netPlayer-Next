import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/song_skeleton.dart';
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
    if(index==songController.nowPlay.value.index && songController.nowPlay.value.playFrom==Pages.loved){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(songController.nowPlay.value.index, preferPosition: AutoScrollPosition.middle);
  }

  Future<void> refresh(BuildContext context) async {
    final start = DateTime.now();
    c.loading.value=true;
    await operations.checkLovedSongPlay(context);
    final elapsed = DateTime.now().difference(start);
    const minDuration = Duration(milliseconds: 200);
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
    c.loading.value=false;
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
              Obx(()=>ViewHeader(title: 'lovedSongs'.tr, subTitle: 'total'.tr+songController.lovedSongs.length.toString()+'songTotal'.tr, page: Pages.loved, locate: locateSong, refresh: ()=>refresh(context), controller: inputController,)),
              const SongHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  c.loading.value ? const SongSkeleton(lovedInclude: true,) : ListView.builder(
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
                            song: songController.lovedSongs[index], 
                            isplay: isPlay(index),
                            from: Pages.loved,
                          )
                        ) : Obx(()=>
                          songController.lovedSongs[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) ||  songController.lovedSongs[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          SongItem(
                            index: index, 
                            isplay: isPlay(index), 
                            from: Pages.loved,
                            song: songController.lovedSongs[index], 
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