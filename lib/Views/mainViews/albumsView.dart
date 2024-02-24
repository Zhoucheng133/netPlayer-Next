// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:net_player_next/Views/mainViews/albumContentView.dart';
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

  // 刷新
  Future<void> reload() async {
    await operations().getAlbums();
    showFlash(
      duration: const Duration(milliseconds: 1500),
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200), 
      builder: (context, controller) => FlashBar(
        behavior: FlashBehavior.floating,
        position: FlashPosition.top,
        backgroundColor: Colors.green[400],
        iconColor: Colors.white,
        margin: EdgeInsets.only(
          top: 30,
          left: (MediaQuery.of(context).size.width-280)/2,
          right: (MediaQuery.of(context).size.width-280)/2
        ),
        icon: Icon(
          Icons.done,
        ),
        controller: controller, 
        content: Text(
          "刷新完成",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      context: context
    );
  }

  // 搜索
  bool onSearch=false;

  void search(value){
    if(value==""){
      setState(() {
        onSearch=false;
      });
    }else{
      setState(() {
        onSearch=true;
      });
    }
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

  List filterBySearch(){
    return c.allAlbums.where((item) => item["title"]!.toLowerCase().contains(searchInput.text.toLowerCase())).toList();
  }

  final ScrollController searchController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
      c.nowPage["id"]=="" && c.nowPage["name"]=="专辑"  ? 
      Padding(
        padding: const EdgeInsets.fromLTRB(20,30,20,20),
        child: Column(
          children: [
            Obx(() => titleBox(title: "专辑", subtitle: "合计${c.allAlbums.length}个专辑", controller: searchInput, reloadList: () => reload(),),),
            SizedBox(height: 10,),
            albumHeader(),
            Expanded(
              child: onSearch ? 
              Obx(() => 
                ListView.builder(
                  controller: searchController,
                  itemCount: filterBySearch().length,
                  itemBuilder: (BuildContext context, int index){
                    return index==filterBySearch().length-1 ? Column(
                      children: [
                        albumItem(index: index, title: filterBySearch()[index]["title"], count: filterBySearch()[index]["songCount"], id: filterBySearch()[index]["id"], artist: filterBySearch()[index]["artist"],),
                        SizedBox(height: 120,),
                      ],
                    ) :
                    albumItem(index: index, title: filterBySearch()[index]["title"], count: filterBySearch()[index]["songCount"], id: filterBySearch()[index]["id"], artist: filterBySearch()[index]["artist"],);
                  }
                )
              ) : Obx(() => 
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
      ) : albumContentView()
    );
  }
}