// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:net_player_next/Views/components/titleBar.dart';

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

  void warning(String title, String content){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("请求所有歌曲失败"),
          content: Text(content),
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

  Future<void> loadList() async {
    var resp=await allSongsRequest();
    
    if(resp["status"]=="ok"){
      c.updateAllSongs(resp["randomSongs"]["song"]);
    }else{
      warning("请求所有歌曲失败", "请检查互联网连接");
    }
  }

  @override
  void initState() {
    super.initState();

    loadList();
  }

  TextEditingController searchInput=TextEditingController();

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
            // 歌曲列表显示在这里
            child: Container(),
          )
        ],
      ),
    );
  }
}