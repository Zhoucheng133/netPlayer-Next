// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/variables/variables.dart';

class playListView extends StatefulWidget {
  const playListView({super.key});

  @override
  State<playListView> createState() => _playListViewState();
}

class _playListViewState extends State<playListView> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    ever(c.pageId, (newVal)=>pageIdListener(newVal));
  }

  void pageIdListener(String newId){
    if(c.pageIndex.value==4){
      setState(() {
        name=c.playLists.firstWhere((item)=>item['id']==newId)['name'];
      });
    }
  }

  String name='';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(()=>viewHeader(title: name, subTitle: '', page: 'playList', id: c.pageId.value),),
              const songHeader(),
            ],
          )
        ],
      )
    );
  }
}