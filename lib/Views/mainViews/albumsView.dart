// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../functions/operations.dart';
import '../../paras/paras.dart';
import '../components/tableHeader.dart';
import '../components/titleBar.dart';

class albumsView extends StatefulWidget {
  const albumsView({super.key});

  @override
  State<albumsView> createState() => _albumsViewState();
}

class _albumsViewState extends State<albumsView> {

  TextEditingController searchInput=TextEditingController();

  Future<void> reload() async {
    await operations().getAlbums();
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
          titleBox(title: "专辑", subtitle: "合计${c.allAlbums.length}个专辑", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 10,),
          albumHeader(),
          Expanded(
            child: Obx(() => 
              ListView.builder(
                controller: controller,
                itemCount: c.allAlbums.length,
                itemBuilder: (BuildContext context, int index){
                  return AutoScrollTag(
                    key: ValueKey(index), 
                    controller: controller, 
                    index: index,
                    child: index==c.allAlbums.length-1 ? 
                      Column(
                        children: [
                          Obx(() => albumItem(index: index, title: c.allAlbums[index]["title"], count: c.allAlbums[index]["songCount"], id: c.allAlbums[index]["id"], artist: c.allAlbums[index]["artist"],)),
                          SizedBox(height: 120,),
                        ],
                      ):
                      Obx(() => albumItem(index: index, title: c.allAlbums[index]["title"], count: c.allAlbums[index]["songCount"], id: c.allAlbums[index]["id"], artist: c.allAlbums[index]["artist"])),
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