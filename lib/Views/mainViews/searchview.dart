// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';

import '../components/titleBar.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

  TextEditingController searchInput=TextEditingController();

  @override
  void initState() {
    super.initState();

    searchInput.addListener(() {
      search(searchInput.text);
    });
  }

  var songList=[];
  var artistList=[];
  var albumList=[];

  void search(String val){
    // TODO 搜索函数
  }

  void reload(){/** 空函数 */}

  var type="歌曲";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(title: "搜索", subtitle: "", controller: searchInput, reloadList: () => reload(), searchType: (value) { setState(() { type=value; }); },),
          SizedBox(height: 10,),
          Expanded(
            child: Column(
              children: [
                if(type=="歌曲") songsHeader()
                else if(type=="专辑") albumHeader()
                else artistsHeader(),


              ],
            ),
          )
        ],
      ),
    );
  }
}