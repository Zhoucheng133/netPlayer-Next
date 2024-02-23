// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/listItems.dart';
import 'package:net_player_next/Views/components/tableHeader.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../functions/operations.dart';
import '../../paras/paras.dart';
import '../components/titleBar.dart';

import 'package:flash/flash.dart';

class artistsView extends StatefulWidget {
  const artistsView({super.key});

  @override
  State<artistsView> createState() => _artistsViewState();
}

class _artistsViewState extends State<artistsView> {

  TextEditingController searchInput=TextEditingController();

  Future<void> reload(context) async {
    await operations().getArtist();
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

  bool onSearch=false;

  // 搜索
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

  List filterBySearch(){
    return c.allArtists.where((item) => item["name"]!.toLowerCase().contains(searchInput.text.toLowerCase())).toList();
  }

  final ScrollController searchController=ScrollController();

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
          Obx(() => titleBox(title: "艺人", subtitle: "合计${c.allArtists.length}位艺人", controller: searchInput, reloadList: () => reload(context),),),
          SizedBox(height: 10,),
          artistsHeader(),
          Expanded(
            child: onSearch ? 
            Obx(() => 
              ListView.builder(
                controller: searchController,
                itemCount: filterBySearch().length,
                itemBuilder: (BuildContext context, int index){
                  return index==filterBySearch().length-1 ? Column(
                    children: [
                      artistItem(index: index, id: filterBySearch()[index]["id"], name: filterBySearch()[index]["name"], count: filterBySearch()[index]["albumCount"]),
                      SizedBox(height: 120,),
                    ],
                  ) :
                  artistItem(index: index, id: filterBySearch()[index]["id"], name: filterBySearch()[index]["name"], count: filterBySearch()[index]["albumCount"]);
                }
              )
            ) : Obx(() => 
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