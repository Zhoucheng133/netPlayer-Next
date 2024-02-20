// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';

import '../components/titleBar.dart';

class artistsView extends StatefulWidget {
  const artistsView({super.key});

  @override
  State<artistsView> createState() => _artistsViewState();
}

class _artistsViewState extends State<artistsView> {

  TextEditingController searchInput=TextEditingController();

  void reload(){
    // TODO 刷新列表
  }

  void search(val){
    // TODO 搜索
  }

  @override
  void initState() {
    super.initState();

    searchInput.addListener(() {
      search(searchInput.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          // TODO 注意传递副标题
          titleBox(title: "艺人", subtitle: "合计x个艺人", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 10,),
          artistsHeader(),
          Expanded(
            // 歌曲列表显示在这里
            child: Container(),
          )
        ],
      ),
    );
  }
}