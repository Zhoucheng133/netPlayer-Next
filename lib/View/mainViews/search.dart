// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/table.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/variables/variables.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

  TextEditingController controller=TextEditingController();
  final Controller c = Get.put(Controller());
  String type='song';

  void changeType(String val){
    setState(() {
      type=val;
    });
  }

  void search(){
    print("hello?");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Column(
            children: [
              searchHeader(
                controller: controller, 
                type: type, 
                changeType: (value) => changeType(value), 
                search: ()=>search(),
              ),
              type=='song' ? const songHeader() : 
              type=='album' ? const albumHeader() :
              const artistHeader()
            ],
          )
        ],
      )
    );
  }
}