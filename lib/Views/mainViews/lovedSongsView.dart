// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class lovedSongsView extends StatefulWidget {
  const lovedSongsView({super.key});

  @override
  State<lovedSongsView> createState() => _lovedSongsViewState();
}

class _lovedSongsViewState extends State<lovedSongsView> {

  void search(value){
    // TODO 搜索歌曲
  }

  void reload(){
    // TODO 刷新列表
  }

  TextEditingController searchInput=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          // TODO 注意传递副标题
          titleBox(searchController: search, title: "喜欢的歌曲", subtitle: "合计x首歌", controller: searchInput, reloadList: () => reload(),),
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