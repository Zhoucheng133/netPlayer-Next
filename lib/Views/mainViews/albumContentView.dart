// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/operations.dart';

import '../../paras/paras.dart';
import '../components/titleBar.dart';

class albumContentView extends StatefulWidget {
  const albumContentView({super.key});

  @override
  State<albumContentView> createState() => _albumContentViewState();
}

class _albumContentViewState extends State<albumContentView> {

  final Controller c = Get.put(Controller());

  var title="";
  var list=[];

  Future<void> getData() async {
    var data={};
    if(c.nowPage["id"]!=null){
      data=await operations().getAlbumData(c.nowPage["id"]!);
    }
    setState(() {
      title=data["title"];
      list=data["list"];
    });
  }

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBoxWithBack(title: "专辑: $title", subtitle: "含有歌曲${list.length}首",)
        ],
      ),
    );
  }
}