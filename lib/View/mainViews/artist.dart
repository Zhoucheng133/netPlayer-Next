// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class artistView extends StatefulWidget {
  const artistView({super.key});

  @override
  State<artistView> createState() => _artistViewState();
}

class _artistViewState extends State<artistView> {

  TextEditingController inputController = TextEditingController();
  final Controller c = Get.put(Controller());
  String searchKeyWord='';
  String artistName='';
  List list=[];
  late Worker listener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Operations().getArtists(context);
    });
    inputController.addListener((){
      setState(() {
        searchKeyWord=inputController.text;
      });
    });
    listener = ever(c.pageId, (String id) async {
      if(c.pageIndex.value==2 && c.pageId.value!=''){
        Map rlt=await Operations().getArtistData(context, id);
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
    Operations().getArtists(context);
    showMessage(true, '更新成功', context);
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
                c.pageId.value=='' ? viewHeader(title: '艺人', subTitle: '共有${c.artists.length}位艺人', page: 'artist', refresh: ()=>refresh(context), controller: inputController,) : 
                viewHeader(title: '艺人: $artistName', subTitle: '共有${list.length}个专辑', page: 'artist')
              ),
              Obx(()=>
                c.pageId.value=='' ? const artistHeader() : const albumHeader(),
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
                        artistItem(
                          id: c.artists[index]['id'], 
                          name: c.artists[index]['name'], 
                          albumCount: c.artists[index]['albumCount'], 
                          index: index
                        )
                      ) : Obx(()=>
                        c.artists[index]['name'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                        artistItem(
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
                      itemBuilder: (BuildContext context, int index)=> searchKeyWord.isEmpty ? albumItem(
                        id: list[index]['id'], 
                        title: list[index]['title'], 
                        artist: list[index]['artist'], 
                        songCount: list[index]['songCount'], 
                        index: index,
                      ): list[index]['title'].toLowerCase().contains(searchKeyWord.toLowerCase()) || list[index]['artist'].toLowerCase().contains(searchKeyWord.toLowerCase()) ? 
                      albumItem(
                        id: list[index]['id'], 
                        title: list[index]['title'], 
                        artist: list[index]['artist'], 
                        songCount: list[index]['songCount'], 
                        index: index,
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