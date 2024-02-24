// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../functions/operations.dart';
import '../../paras/paras.dart';
import '../components/listItems.dart';
import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class artistContentView extends StatefulWidget {
  const artistContentView({super.key});

  @override
  State<artistContentView> createState() => _artistContentViewState();
}

class _artistContentViewState extends State<artistContentView> {

  final Controller c = Get.put(Controller());

  var title="";
  var list=[];

  Future<void> getData() async {
    if(c.nowPage["id"]=="" || c.nowPage["name"]!="艺人"){
      return;
    }
    var data={};
    if(c.nowPage["id"]!=null){
      data=await operations().getArtistData(c.nowPage["id"]??"");
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

  final ScrollController controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBoxWithBack(title: "艺人: $title", subtitle: "含有专辑${list.length}个",),
          SizedBox(height: 10,),
          albumHeader(),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return index==list.length-1 ? Column(
                  children: [
                    albumItem(index: index, title: list[index]["title"], count: list[index]["songCount"], id: list[index]["id"], artist: list[index]["artist"],),
                    SizedBox(height: 120,),
                  ],
                ):
                albumItem(index: index, title: list[index]["title"], count: list[index]["songCount"], id: list[index]["id"], artist: list[index]["artist"]);
              }
            )
          )
        ],
      ),
    );
  }
}