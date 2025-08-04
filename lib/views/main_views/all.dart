import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController inputController = TextEditingController();

  String searchKeyWord='';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getAllSongs(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
  }

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='all'){
      return true;
    }
    return false;
  }

  void locateSong(){
    controller.scrollToIndex(c.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
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
              Obx(() => ViewHeader(title: 'allSongs'.tr, subTitle: 'total'.tr+c.allSongs.length.toString()+'songTotal'.tr, page: 'all', locate: ()=>locateSong(), refresh: ()=>refresh(context), controller: inputController,),),
              const SongHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    controller: controller,
                    itemCount: c.allSongs.length,
                    itemBuilder: (BuildContext context, int index){
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: searchKeyWord.isEmpty ? Obx(() => SongItem(
                            index: index, 
                            title: c.allSongs[index]['title'], 
                            duration: c.allSongs[index]['duration'], 
                            id: c.allSongs[index]['id'], 
                            isplay: isPlay(index), 
                            artist: c.allSongs[index]['artist'], 
                            from: 'all', 
                            album: c.allSongs[index]['album'], 
                            artistId: c.allSongs[index]['artistId']??'',
                            albumId: c.allSongs[index]['albumId']??'',
                            created: c.allSongs[index]['created']??'',
                          )
                        ) : Obx(()=>
                          c.allSongs[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || c.allSongs[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                          SongItem(
                            index: index, 
                            title: c.allSongs[index]['title'], 
                            duration: c.allSongs[index]['duration'], 
                            id: c.allSongs[index]['id'], 
                            isplay: isPlay(index), 
                            artist: c.allSongs[index]['artist'], 
                            from: 'all',
                            album: c.allSongs[index]['album'], 
                            artistId: c.allSongs[index]['artistId']??'',
                            albumId: c.allSongs[index]['albumId']??'',
                            created: c.allSongs[index]['created']??'',
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