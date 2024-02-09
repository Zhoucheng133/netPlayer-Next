// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/Views/components/titleBar.dart';
import 'package:net_player_next/functions/operations.dart';
import '../../functions/request.dart';
import '../../paras/paras.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key});

  @override
  State<allSongsView> createState() => _allSongsViewState();
}


class _allSongsViewState extends State<allSongsView> {

  final Controller c = Get.put(Controller());

  void search(value){
    // TODO 搜索歌曲
  }

  void reload(){
    // TODO 刷新列表
  }

  Future<void> loadList() async {
    if(c.allSongs.isNotEmpty){
      return;
    }
    var resp=await allSongsRequest();
    if(resp["status"]=="ok"){
      var tmpList=resp["randomSongs"]["song"];
      tmpList.sort((a, b) {
        DateTime dateTimeA = DateTime.parse(a['created']);
        DateTime dateTimeB = DateTime.parse(b['created']);
        return dateTimeB.compareTo(dateTimeA);
      });
      c.updateAllSongs(tmpList);
    }else{
      showDialog(
        context: context, 
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("请求所有歌曲失败"),
            content: Text("请检查互联网连接"),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context), 
                child: Text("好的"),
              )
            ],
          );
        }
      );
    }
  }

  @override
  void initState() {
    super.initState();

    operations().getAllSongs(context);
  }

  TextEditingController searchInput=TextEditingController();

  var controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => 
            titleBox(searchController: search, title: "所有歌曲", subtitle: "合计${c.allSongs.length}首歌", controller: searchInput, reloadList: () => reload(),),
          ),
          SizedBox(height: 10,),
          songsHeader(),
          Expanded(
            child: Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.allSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return index==c.allSongs.length-1 ? 
                  Column(
                    children: [
                      songItem(artist: c.allSongs[index]["artist"], duration: c.allSongs[index]["duration"], index: index, title: c.allSongs[index]["title"], isLoved: operations().isLoved(c.allSongs[index]["id"]),),
                      SizedBox(height: 120,),
                    ],
                  ):
                  songItem(artist: c.allSongs[index]["artist"], duration: c.allSongs[index]["duration"], index: index, title: c.allSongs[index]["title"], isLoved: operations().isLoved(c.allSongs[index]["id"]),);
                }
              )
            )
          ),
        ],
      ),
    );
  }
}