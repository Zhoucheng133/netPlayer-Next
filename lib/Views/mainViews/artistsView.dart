// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../paras/paras.dart';
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

  final Controller c = Get.put(Controller());
  var controller=AutoScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          Obx(() => titleBox(title: "艺人", subtitle: "合计${c.allArtists.length}位艺人", controller: searchInput, reloadList: () => reload(),),),
          SizedBox(height: 10,),
          artistsHeader(),
          Expanded(
            child: Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.allArtists.length,
                itemBuilder: (BuildContext context, int index){
                  return AutoScrollTag(
                    key: ValueKey(index), 
                    controller: controller, 
                    index: index,
                    child: index==c.allArtists.length-1 ? 
                      Column(
                        children: [
                          Obx(() => artistItem(index: index, id: c.allArtists[index]["id"], name: c.allArtists[index]["name"], count: c.allArtists[index]["albumCount"])),
                          SizedBox(height: 120,),
                        ],
                      ):
                      Obx(() => artistItem(index: index, id: c.allArtists[index]["id"], name: c.allArtists[index]["name"], count: c.allArtists[index]["albumCount"])),
                  );
                }
              )
            ),
          )
        ],
      ),
    );
  }
}