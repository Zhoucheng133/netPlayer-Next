// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class albumsView extends StatefulWidget {
  const albumsView({super.key});

  @override
  State<albumsView> createState() => _albumsViewState();
}

class _albumsViewState extends State<albumsView> {

  TextEditingController searchInput=TextEditingController();

  void reload(){
    // TODO 刷新列表
  }

  void search(val){
    // TODO 搜索
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          // TODO 注意传递副标题
          titleBox(title: "专辑", subtitle: "合计x个专辑", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 10,),
          albumHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: Container(),
          )
        ],
      ),
    );
  }
}