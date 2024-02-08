// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:net_player_next/Views/components/titleBar.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key});

  @override
  State<allSongsView> createState() => _allSongsViewState();
}


class _allSongsViewState extends State<allSongsView> {

  void search(value){
    // TODO 搜索歌曲
    print(value);
  }

  TextEditingController searchInput=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(searchController: search, title: "所有歌曲", subtitle: "合计x首歌", controller: searchInput,)
        ],
      ),
    );
  }
}