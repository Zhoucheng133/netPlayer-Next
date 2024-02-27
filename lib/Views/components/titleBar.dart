// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/searchType.dart';

import '../../paras/paras.dart';
// import 'package:flutter/cupertino.dart';

class titleBox extends StatefulWidget {

  final String title;
  final String subtitle;
  final TextEditingController controller;
  final VoidCallback reloadList;
  final dynamic scrollToIndex;
  final ValueChanged searchType;

  const titleBox({super.key, required this.title, required this.subtitle, required this.controller, required this.reloadList, this.scrollToIndex, required this.searchType});

  @override
  State<titleBox> createState() => _titleBoxState();
}

class _titleBoxState extends State<titleBox> {

  final Controller c = Get.put(Controller());

  FocusNode textfocus=FocusNode();

  bool hoverLocate=false;
  bool hoverReload=false;

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

  bool enablePosition(){
    if(c.nowPage["name"]==c.playInfo["playFrom"]){
      if(c.nowPage["name"]=="所有歌曲" || c.nowPage["name"]=="喜欢的歌曲"){
        return true;
      }else if(c.nowPage["id"]==c.playInfo["listId"]){
        return true;
      }
    }
    return false;
  }

  void searchTypeChange(val){
    widget.searchType(val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromARGB(255, 203, 255, 144),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 30,),
                widget.title=="搜索" ? searchType(typeChanged: (value) => searchTypeChange(value)) : Container()
              ],
            )
          ),
          widget.title!="专辑" && widget.title!="艺人" && widget.title!="搜索" && widget.title!="设置" ?
          Obx(() => enablePosition() ? 
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverLocate=true; }),
              onExit: (event) => setState(() { hoverLocate=false; }),
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                tween: ColorTween(begin: Colors.grey[800], end: hoverLocate ? c.hoverColor : Colors.grey[800]),
                builder: (_, value, __){
                  return GestureDetector(
                    onTap: (){
                      widget.scrollToIndex();
                    },
                    child: Icon(
                      Icons.my_location_rounded,
                      size: 20,
                      color: value,
                    ),
                  );
                },
              ),
            ) : MouseRegion(
              cursor: SystemMouseCursors.forbidden,
              child: Icon(
                Icons.my_location_rounded,
                size: 20,
                color: Colors.grey,
              ),
            ) ,
          ): Container(),
          SizedBox(width: 10,),
          widget.title!="设置" ?
          Stack(
            children: [
              SizedBox(
                width: 200,
                child: Center(
                  child: TextField(
                    focusNode: textfocus,
                    controller: widget.controller,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: c.hoverColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 210, 210, 210),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                )
              ),
              Positioned(
                child: SizedBox(
                  width: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container()),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 5,)
                    ],
                  )
                )
              ),
            ],
          ) : Container(),
          SizedBox(width: 20,),
          widget.title!="搜索" && widget.title!="设置" ?
          GestureDetector(
            onTap: () => widget.reloadList(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverReload=true; }),
              onExit: (event) => setState(() { hoverReload=false; }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hoverReload ? c.hoverColor : c.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}

class titleBoxWithBack extends StatefulWidget {
  final String title;
  final String subtitle;
  
  const titleBoxWithBack({super.key, required this.title, required this.subtitle});

  @override
  State<titleBoxWithBack> createState() => _titleBoxWithBackState();
}

class _titleBoxWithBackState extends State<titleBoxWithBack> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    c.updateNowPage({
                      "name": c.nowPage["name"]??"所有歌曲",
                      "id": "",
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.arrow_back_rounded)
                  ),
                ),
                SizedBox(width: 10,),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}