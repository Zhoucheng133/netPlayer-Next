// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class sideBarItem extends StatefulWidget {
  final String name;
  final IconData icon;
  final int index;

  const sideBarItem({super.key, required this.name, required this.icon, required this.index});

  @override
  State<sideBarItem> createState() => _sideBarItemState();
}

class _sideBarItemState extends State<sideBarItem> {

  final Controller c = Get.put(Controller());
  bool onHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        c.pageNow.value={
          'index': widget.index,
          'id': null,
        };
      },
      child: MouseRegion(
        onEnter: (_){
          setState(() {
            onHover=true;
          });
        },
        onExit: (_){
          setState(() {
            onHover=false;
          });
        },
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5),
          child: Obx(()=>
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: c.pageNow['index']==widget.index ? c.color3 :  onHover ? c.color2 : c.color1,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 16,
                    ),
                    const SizedBox(width: 5,),
                    Text(widget.name)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class playListLabel extends StatefulWidget {
  final VoidCallback addPlayListHandler;
  const playListLabel({super.key, required this.addPlayListHandler});

  @override
  State<playListLabel> createState() => _playListLabelState();
}

class _playListLabelState extends State<playListLabel> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('歌单'),
              GestureDetector(
                onTap: (){
                  widget.addPlayListHandler();
                },
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.add_rounded,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 2,
            // color: c.color3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: c.color3
            ),
          ),
        )
      ],
    );
  }
}

class AccountPart extends StatefulWidget {
  final VoidCallback logoutHandler;
  const AccountPart({super.key, required this.logoutHandler});

  @override
  State<AccountPart> createState() => _AccountPartState();
}

class _AccountPartState extends State<AccountPart> {

  final Controller c = Get.put(Controller());

  var hoverSetting=false;
  var hoverLogout=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (){
                c.pageNow.value={
                  'index': 5,
                  'id': null,
                };
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_){
                  setState(() {
                    hoverSetting=true;
                  });
                },
                onExit: (_){
                  setState(() {
                    hoverSetting=false;
                  });
                },
                child: AnimatedContainer(
                  height: 35,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: c.pageNow['index']==5 ? c.color3 : hoverSetting ? c.color2 : c.color1,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.settings_rounded,
                      size: 16,
                    ),
                  ),
                ),
              ),
            )
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                widget.logoutHandler();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_){
                  setState(() {
                    hoverLogout=true;
                  });
                },
                onExit: (_){
                  setState(() {
                    hoverLogout=false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: hoverLogout ? c.color2 : c.color1,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.logout_rounded,
                      size: 16,
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}