// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class lyricView extends StatefulWidget {
  const lyricView({super.key});

  @override
  State<lyricView> createState() => _lyricViewState();
}

class _lyricViewState extends State<lyricView> {

  bool hoverBack=false;
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container()
                ),
                Expanded(
                  child: Container()
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: GestureDetector(
              onTap: (){
                Operations().toggleLyric(context);
              },
              child: MouseRegion(
                onEnter: (_){
                  setState(() {
                    hoverBack=true;
                  });
                },
                onExit: (_){
                  setState(() {
                    hoverBack=false;
                  });
                },
                cursor: SystemMouseCursors.click,
                child: TweenAnimationBuilder(
                  tween: ColorTween(end: hoverBack ? c.color6 : c.color4), 
                  duration: const Duration(milliseconds: 200),
                  builder: (_, value, __)=>Icon(
                    Icons.arrow_downward_rounded,
                    color: value,
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}