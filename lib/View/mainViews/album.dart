// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class albumView extends StatefulWidget {
  const albumView({super.key});

  @override
  State<albumView> createState() => _albumViewState();
}

class _albumViewState extends State<albumView> {

  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Operations().getAlbums(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              Obx(() => viewHeader(title: '专辑', subTitle: '共有${c.albums.length}个专辑', page: 'album',),),
              const albumHeader(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height - 222,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.albums.length,
                    itemBuilder: (BuildContext context, int index)=>Obx(()=>
                      albumItem(id: c.albums[index]['id'], title: c.albums[index]['title'], artist: c.albums[index]['artist'], songCount: c.albums[index]['songCount'], index: index,)
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