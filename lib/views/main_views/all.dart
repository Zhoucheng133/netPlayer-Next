import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AllView extends StatefulWidget {
  const AllView({super.key});

  @override
  State<AllView> createState() => _AllViewState();
}

class _AllViewState extends State<AllView> {

  final operations=Operations();
  final Controller c = Get.find();
  final AutoScrollController controller=AutoScrollController();
  final SongController songController=Get.find();
  final ColorController colorController=Get.find();
  TextEditingController inputController = TextEditingController();

  String searchKeyWord='';

  bool loading=true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await operations.getAllSongs(context);
      setState(() {
        loading=false;
      });
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
  }

  bool isPlay(int index){
    if(index==songController.nowPlay.value.index && songController.nowPlay.value.playFrom==Pages.all){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(songController.nowPlay.value.index, preferPosition: AutoScrollPosition.middle);
  }

  Future<void> refresh(BuildContext context) async {
    await operations.checkAllSongPlay(context);
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
              Obx(() => ViewHeader(title: 'allSongs'.tr, subTitle: 'total'.tr+songController.allSongs.length.toString()+'songTotal'.tr, page: Pages.all, locate: ()=>locateSong(), refresh: ()=>refresh(context), controller: inputController,),),
              const SongHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  loading ? LoadingAnimationWidget.beat(
                    color: colorController.color6(), 
                    size: 30
                  ) : ListView.builder(
                    controller: controller,
                    itemCount: songController.allSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: searchKeyWord.isEmpty ? Obx(() => SongItem(
                            index: index, 
                            song: songController.allSongs[index],
                            isplay: isPlay(index), 
                            from: Pages.all, 
                          )
                        ) : Obx(()=>
                          songController.allSongs[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) || songController.allSongs[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          SongItem(
                            index: index, 
                            isplay: isPlay(index), 
                            from: Pages.all,
                            song: songController.allSongs[index],
                          ) : Container()
                        ),
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