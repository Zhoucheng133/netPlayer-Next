import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/album_controller.dart';
import 'package:net_player_next/views/components/album_item.dart';
import 'package:net_player_next/views/components/album_skeleton.dart';
import 'package:net_player_next/views/components/artist_skeleton.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/artist_item.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class ArtistView extends StatefulWidget {
  const ArtistView({super.key});

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {

  TextEditingController inputController = TextEditingController();
  final Controller c = Get.find();
  String searchKeyWord='';
  String artistName='';
  List<AlbumItemClass> list=[];
  late Worker listener;
  final operations=Operations();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getArtists(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
    listener = ever(c.pageId, (String id) async {
      if(c.page.value==Pages.artist && c.pageId.value!=''){
        final start = DateTime.now();
        c.loading.value=true;
        Map rlt=await operations.getArtistData(context, id);
        if(rlt.isNotEmpty){
          try {
            setState(() {
              artistName=rlt['name'];
              final List tempList=rlt['album'];
              list=tempList.map((item)=>AlbumItemClass.fromJson(item)).toList();
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
    await operations.getArtists(context);
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
              Obx(()=>
                c.pageId.value=='' ? ViewHeader(title: 'artists'.tr, subTitle: 'total'.tr+c.artists.length.toString()+'artistTotal'.tr, page: Pages.artist, refresh: ()=>refresh(context), controller: inputController,) : 
                ViewHeader(title: "${'artist'.tr}: $artistName", subTitle: 'total'.tr+list.length.toString()+'albumTotal'.tr, page: Pages.artist)
              ),
              Obx(()=>
                c.pageId.value=='' ? const ArtistHeader() : const AlbumHeader(),
              ),
              Obx(()=>
                c.pageId.value=='' ?
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  height: MediaQuery.of(context).size.height - 222,
                  child: Obx(()=>
                    c.loading.value ? const ArtistSkeleton() : ListView.builder(
                      itemCount: c.artists.length,
                      itemBuilder:  (BuildContext context, int index)=> searchKeyWord.isEmpty ? Obx(()=>
                        ArtistItem(
                          id: c.artists[index]['id'], 
                          name: c.artists[index]['name'], 
                          albumCount: c.artists[index]['albumCount'], 
                          index: index
                        )
                      ) : Obx(()=>
                        c.artists[index]['name'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        ArtistItem(
                          id: c.artists[index]['id'], 
                          name: c.artists[index]['name'], 
                          albumCount: c.artists[index]['albumCount'], 
                          index: index
                        ) : Container()
                      )
                    )
                  ),
                ):
                SizedBox(
                  width: MediaQuery.of(context).size.width - 200,
                  height: MediaQuery.of(context).size.height - 222,
                  child: Obx(()=>
                    c.loading.value ? const AlbumSkeleton() : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index)=> searchKeyWord.isEmpty ? AlbumItem(
                        data: list[index], 
                        index: index, 
                        clearSearch: () {  },
                      ): list[index].title.toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index].artist.toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                      AlbumItem(
                        data: list[index], 
                        index: index, clearSearch: () {
                          setState(() {
                            inputController.text='';
                          });
                        },
                      ) : Container()
                    )
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