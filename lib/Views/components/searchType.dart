// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../paras/paras.dart';

class searchType extends StatefulWidget {
  
  final ValueChanged typeChanged;

  const searchType({super.key, required this.typeChanged});

  @override
  State<searchType> createState() => _searchTypeState();
}

class _searchTypeState extends State<searchType> {

  FocusNode textfocus=FocusNode();
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();

    textfocus.addListener(() { 
      if(textfocus.hasFocus){
        c.updateFocusTextField(true);
      }else{
        c.updateFocusTextField(false);
      }
    });
  }

  var inputAreaWidth=300.0;

  Set<String> searchType = {"歌曲"};

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: [
        ButtonSegment(
          value: "歌曲",
          label: Text("歌曲"),
        ),
        ButtonSegment(
          value: "艺人",
          label: Text("艺人"),
        ),
        ButtonSegment(
          value: "专辑",
          label: Text("专辑"),
        ),
      ], 
      selected: searchType,
      onSelectionChanged: (val){
        setState(() {
          searchType={val.first};
        });
        widget.typeChanged(val.first);
      },
    );
  }
}