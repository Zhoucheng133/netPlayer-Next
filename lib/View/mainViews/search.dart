// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

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
              searchHeader(
                controller: controller, 
                type: type, 
                changeType: (value) => changeType(value), 
                search: ()=>search(context),
              ),
              type=='song' ? const songHeader() : 
              type=='album' ? const albumHeader() :
              const artistHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: type=='song' ? ListView.builder(
                  itemCount: songList.length,
                  itemBuilder: (BuildContext context, int index)=>Obx(()=>
                    songItem(
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
                    )
                  )
                ) : type=='album' ? ListView.builder(
                  itemCount: albumList.length,
                  itemBuilder: (BuildContext context, int index)=> albumItem(
                    id: albumList[index]['id'], 
                    title: albumList[index]['title'], 
                    artist: albumList[index]['artist'], 
                    songCount: albumList[index]['songCount'], 
                    index: index, 
                    clearSearch: () {}
                  )
                ) : ListView.builder(
                  itemCount: artistList.length,
                  itemBuilder:  (BuildContext context, int index)=> artistItem(
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