import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/table.dart';
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
  List list=[];
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
      if(c.pageIndex.value==2 && c.pageId.value!=''){
        Map rlt=await operations.getArtistData(context, id);
        if(rlt.isNotEmpty){
          try {
            setState(() {
              artistName=rlt['name'];
              list=rlt['album'];
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
    operations.getArtists(context);
    showMessage(true, 'updateOk'.tr, context);
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
                c.pageId.value=='' ? ViewHeader(title: 'artists'.tr, subTitle: 'total'.tr+c.artists.length.toString()+'artistTotal'.tr, page: 'artist', refresh: ()=>refresh(context), controller: inputController,) : 
                ViewHeader(title: "${'artist'.tr}: $artistName", subTitle: 'total'.tr+list.length.toString()+'albumTotal'.tr, page: 'artist')
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
                    ListView.builder(
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
                    ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index)=> searchKeyWord.isEmpty ? AlbumItem(
                        id: list[index]['id'], 
                        title: list[index]['title'], 
                        artist: list[index]['artist'], 
                        songCount: list[index]['songCount'], 
                        index: index, 
                        clearSearch: () {  },
                        artistId: c.albums[index]['artistId'],
                      ): list[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                      AlbumItem(
                        id: list[index]['id'], 
                        title: list[index]['title'], 
                        artist: list[index]['artist'], 
                        songCount: list[index]['songCount'], 
                        index: index, clearSearch: () {
                          setState(() {
                            inputController.text='';
                          });
                        },
                        artistId: c.albums[index]['artistId'],
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