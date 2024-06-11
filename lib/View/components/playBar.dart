// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class playBar extends StatefulWidget {
  const playBar({super.key});

  @override
  State<playBar> createState() => _playBarState();
}

class _playBarState extends State<playBar> {

  final Controller c = Get.put(Controller());

  bool hoverPause=false;
  bool hoverPre=false;
  bool hoverSkip=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 封面
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Obx(() =>
                c.nowPlay["id"]=="" ? 
                Container(
                  color: c.color1,
                ) : Image.network(
                  "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}",
                  fit: BoxFit.contain,
                ),
              ),
            )
          ),
          const SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 165,
                child: Obx(() => 
                  Text(
                    c.nowPlay['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              // const SizedBox(height: 5,),
              SizedBox(
                width: 165,
                child: Obx(()=>
                  Text(
                    c.nowPlay['artist'],
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // TODO 上一首
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverPre=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverPre=false;
                          });
                        },
                        child: TweenAnimationBuilder(
                          tween: ColorTween(end: hoverPre ? c.color6 : c.color5), 
                          duration: const Duration(milliseconds: 200),
                          builder: (_, value, __) => Icon(
                            Icons.skip_previous_rounded,
                            color: value,
                          ),
                        )
                      ),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: (){
                        Operations().toggleSong();
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverPause=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverPause=false;
                          });
                        },
                        child: AnimatedContainer(
                          height: 34,
                          width: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: hoverPause ? c.color6 : c.color5
                          ),
                          duration: const Duration(milliseconds: 200),
                          child: Center(
                            child: Obx(()=>
                              c.isPlay.value ? const Icon(
                                Icons.pause_rounded,
                                color: Colors.white,
                              ): const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                              )
                            )
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15,),
                    GestureDetector(
                      onTap: (){
                        // TODO 下一首
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverSkip=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverSkip=false;
                          });
                        },
                        child: TweenAnimationBuilder(
                          tween: ColorTween(end: hoverSkip ? c.color6 : c.color5), 
                          duration: const Duration(milliseconds: 200),
                          builder: (_, value, __) => Icon(
                            Icons.skip_next_rounded,
                            color: value,
                          ),
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Obx(()=>
                  SliderTheme(
                    data: SliderThemeData(
                      overlayColor: Colors.transparent,
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                      trackHeight: 1,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                        elevation: 0,
                        pressedElevation: 0,
                      ),
                      thumbColor: c.color6,
                      activeTrackColor: c.color4,
                      inactiveTrackColor: c.color3,
                    ),
                    child: Slider(
                      value: c.nowPlay['duration']==0 ? 0.0 : c.playProgress.value/1000/c.nowPlay["duration"]>1 ? 1.0 : c.playProgress.value/1000/c.nowPlay["duration"]<0 ? 0 : c.playProgress.value/1000/c.nowPlay["duration"], 
                      onChanged: (value){
                        // TODO 跳转时间轴
                      }
                    ),
                  )
                )
              ],
            )
          ),
          const SizedBox(width: 10,),
          const SizedBox(
            width: 210,
            // TODO 其他的一些组件
          )
        ],
      ),
    );
  }
}