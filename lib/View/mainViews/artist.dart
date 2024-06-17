// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class artistView extends StatefulWidget {
  const artistView({super.key});

  @override
  State<artistView> createState() => _artistViewState();
}

class _artistViewState extends State<artistView> {

  TextEditingController inputController = TextEditingController();
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Operations().getArtists(context);
    });
  }

  void refresh(){
    // TODO 刷新艺人列表
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              viewHeader(title: '艺人', subTitle: '', page: 'artist', refresh: ()=>refresh(), controller: inputController,),
              const artistHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.artists.length,
                    itemBuilder:  (BuildContext context, int index)=>Obx(()=>
                      artistItem(id: c.artists[index]['id'], name: c.artists[index]['name'], albumCount: c.artists[index]['albumCount'], index: index)
                    )
                  )
                ),
              )
            ],
          )
        ],
      )
    );
  }
}