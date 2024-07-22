import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/views/components/table.dart';
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
  final Controller c = Get.put(Controller());
  String type='song';

  List songList=[];
  List albumList=[];
  List artistList=[];

  String nowSearch='';

  void changeType(String val){
    setState(() {
      type=val;
    });
  }

  bool isPlay(int index){
    if(index==c.nowPlay['index'] && c.nowPlay['playFrom']=='search' && c.nowPlay['fromId']==nowSearch){
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
    Map data=await Operations().getSearch(context, controller.text);
    try {
      setState(() {
        songList=data['songs'];
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
                      title: songList[index]['title'], 
                      duration: songList[index]['duration'], 
                      id: songList[index]['id'], 
                      isplay: isPlay(index), 
                      artist: songList[index]['artist'], 
                      from: 'search', 
                      album: songList[index]['album'],
                      list: songList,
                      listId: nowSearch, 
                      artistId: songList[index]['artistId']??'', 
                      albumId: songList[index]['albumId']??'',
                    )
                  )
                ) : type=='album' ? ListView.builder(
                  itemCount: albumList.length,
                  itemBuilder: (BuildContext context, int index)=> AlbumItem(
                    id: albumList[index]['id'], 
                    title: albumList[index]['title'], 
                    artist: albumList[index]['artist'], 
                    songCount: albumList[index]['songCount'], 
                    index: index, 
                    clearSearch: () {}
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