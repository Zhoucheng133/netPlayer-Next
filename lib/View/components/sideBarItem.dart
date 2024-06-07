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
                color: c.pageNow['index']==widget.index ? const Color.fromARGB(255, 233, 236, 255) :  onHover ? const Color.fromARGB(255, 238, 241, 255) : const Color.fromRGBO(248, 249, 255, 1),
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