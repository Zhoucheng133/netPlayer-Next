import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/album_item.dart';
import 'package:net_player_next/views/components/song_item.dart';
import 'package:net_player_next/views/components/artist_item.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  TextEditingController controller=TextEditingController();
  final SongController songController=Get.find();
  final operations=Operations();
  final Controller c = Get.find();
  String type='song';

  List<SongItemClass> songList=[];
  List albumList=[];
  List artistList=[];

  String nowSearch='';

  void changeType(String val){
    setState(() {
      type=val;
    });
  }

  bool isPlay(int index){
    if(index==songController.nowPlay.value.index && songController.nowPlay.value.playFrom==Pages.search && songController.nowPlay.value.fromId==nowSearch){
      return true;
    }
    return false;
  }

  Future<void> search(BuildContext context) async {
    if(controller.text.isEmpty){
      return;
    }
    setState(() {
      nowSearch=controller.text;
    });
    Map data=await operations.getSearch(context, controller.text);
    try {
      final List songs=data['songs'];
      setState(() {
        songList=songs.map((item)=>SongItemClass.fromJson(item)).toList();
        for (var item in songList) {
          item.fromId=controller.text;
        }
        albumList=data['albums'];
        artistList=data['artists'];
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    controller.addListener((){
      if(controller.text.isEmpty){
        setState(() {
          songList=[];
          albumList=[];
          artistList=[];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              SearchHeader(
                controller: controller, 
                type: type, 
                changeType: (value) => changeType(value), 
                search: ()=>search(context),
              ),
              type=='song' ? const SongHeader() : 
              type=='album' ? const AlbumHeader() :
              const ArtistHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: type=='song' ? ListView.builder(
                  itemCount: songList.length,
                  itemBuilder: (BuildContext context, int index)=>Obx(()=>
                    SongItem(
                      index: index, 
                      song: songList[index], 
                      isplay: isPlay(index), 
                      from: Pages.search, 
                      list: songList,
                    )
                  )
                ) : type=='album' ? ListView.builder(
                  itemCount: albumList.length,
                  itemBuilder: (BuildContext context, int index)=> AlbumItem(
                    index: index, 
                    clearSearch: () {},
                    data: c.albums[index],
                  )
                ) : ListView.builder(
                  itemCount: artistList.length,
                  itemBuilder:  (BuildContext context, int index)=> ArtistItem(
                    id: artistList[index]['id'], 
                    name: artistList[index]['name'], 
                    albumCount: artistList[index]['albumCount'], 
                    index: index
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