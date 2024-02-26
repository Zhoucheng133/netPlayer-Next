// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/operations.dart';

import '../../paras/paras.dart';

class playBar extends StatefulWidget {
  const playBar({super.key});

  @override
  State<playBar> createState() => _playBarState();
}

class _playBarState extends State<playBar> {

  final Controller c = Get.put(Controller());

  Timer? _debounce;

  void jumpDuration(double val){
    if(c.playInfo.isEmpty){
      return;
    }
    operations().pause();
    var progress=c.playInfo["duration"]*1000*val;
     c.updatePlayProgress(progress.toInt());
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 100), () {
      if(c.playInfo["duration"]==null){
        return;
      }else{
        operations().seek(Duration(milliseconds: progress.toInt()));
      }
    });
  }

  String convertTime(){
    if(c.playInfo["duration"]==null){
      return "00:00/00:00";
    }else{
      var nowPlay = c.playProgress ~/ 1000;
      var nowPlayDisplay = "${(nowPlay ~/ 60).toString().padLeft(2, '0')}:${(nowPlay % 60).toString().padLeft(2, '0')}";
      
      var durationDisplay = "${(c.playInfo["duration"] ~/ 60).toString().padLeft(2, '0')}:${(c.playInfo["duration"] % 60).toString().padLeft(2, '0')}";
      
      return "$nowPlayDisplay/$durationDisplay";
    }
  }

  void loveToggle(){
    if(operations().isLoved(c.playInfo["id"])){
      operations().delove(c.playInfo["id"]);
    }else{
      operations().love(c.playInfo["id"]);
    }
  }

  bool onHover=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(149, 190, 190, 190),
            offset: Offset(0, 0),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                // TODO 显示歌词
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (val) {
                  setState(() {
                    onHover=true;
                  });
                },
                onExit: (val) {
                  setState(() {
                    onHover=false;
                  });
                },
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Obx(() =>
                          c.playInfo["id"]==null ? 
                          Image.asset(
                            "assets/blank.jpg",
                            fit: BoxFit.contain,
                          ) : Image.network(
                            "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}",
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: AnimatedOpacity(
                        opacity: onHover?1:0, 
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(100, 0, 0, 0)
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    )
                  ]
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 250.0,
                          ),
                          child: Obx(() => 
                            Text(
                              c.playInfo["title"] ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 200.0,
                          ),
                          child: Obx(() => 
                            Text(
                              " - ${c.playInfo["artist"] ?? ""}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                                overflow: TextOverflow.ellipsis
                              ),
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Obx(() => 
                      Text(
                        convertTime(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                      )
                    )
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      overlayColor: Colors.transparent,
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                        elevation: 0,
                        pressedElevation: 0,
                      )
                    ), 
                    child: Obx(() => 
                      Slider(
                        value: c.playInfo["duration"]==null ? 0.0 : (c.playProgress.value/1000/c.playInfo["duration"]) <= 1 ? (c.playProgress.value/1000/c.playInfo["duration"]) : 1,
                        onChanged: (value) => jumpDuration(value)
                      )
                    )
                  )
                ],
              ),
            ),
            SizedBox(width: 20,),
            GestureDetector(
              onTap: () => loveToggle(),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Obx(() => 
                  c.playInfo["id"]!=null &&  operations().isLoved(c.playInfo["id"]) ?
                  Icon(
                    Icons.favorite_rounded,
                    color: Colors.red,
                    size: 20,
                  ) : Icon(
                    Icons.favorite_border_outlined,
                    size: 20,
                  )
                ),
              )
            ),
            SizedBox(width: 25,),
            playMode(),
            SizedBox(width: 15,),
            playBarItem(icon: Icons.skip_previous_rounded, func: operations().preSong),
            SizedBox(width: 5,),
            Obx(() => 
              c.isPlay.value ? playBarItem(icon: Icons.pause_rounded, func: operations().toggleSong, iconSize: 35.0, containerSize: 50.0,) : 
              playBarItem(icon: Icons.play_arrow_rounded, func: operations().toggleSong, iconSize: 35.0, containerSize: 50.0,)
            ),
            SizedBox(width: 5,),
            playBarItem(icon: Icons.skip_next_rounded, func: operations().nextSong),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}

class playMode extends StatefulWidget {
  const playMode({super.key});

  @override
  State<playMode> createState() => _playModeState();
}

class _playModeState extends State<playMode> {

  final Controller c = Get.put(Controller());

  IconData playModeIcon(){
    if(c.fullRandomPlay.value){
      return Icons.shuffle_rounded;
    }

    if(c.playMode.value=="顺序播放"){
      return Icons.repeat_rounded;
    }else if(c.playMode.value=="随机播放"){
      return Icons.shuffle_rounded;
    }else{
      return Icons.repeat_one_rounded;
    }
  }

  Future<void> menuShown(BuildContext context, TapDownDetails details) async {
    if(c.fullRandomPlay.value){
      return;
    }
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val = await showMenu(
      context: context,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ), 
      items: [
        PopupMenuItem(
          value: "顺序播放",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.repeat_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("顺序播放")
            ],
          ),
        ),
        PopupMenuItem(
          value: "随机播放",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.shuffle_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("随机播放")
            ],
          ),
        ),
        PopupMenuItem(
          value: "单曲循环",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.repeat_one_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("单曲循环")
            ],
          ),
        ),
      ],
    );
    if(val!=null){
      c.updatePlayMode(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => menuShown(context, details),
      child: Obx(() => 
        MouseRegion(
          cursor: c.fullRandomPlay.value ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
          child: Obx(() => 
            Icon(
              playModeIcon(),
              size: 20,
              color: c.fullRandomPlay.value ? Colors.grey : Colors.black
            ),
          )
        ),
      )
    );
  }
}


class playBarItem extends StatefulWidget {

  final IconData icon;
  final VoidCallback func;
  final dynamic iconSize;
  final dynamic containerSize;

  const playBarItem({super.key, required this.icon, required this.func, this.iconSize, this.containerSize});

  @override
  State<playBarItem> createState() => _playBarItemState();
}

class _playBarItemState extends State<playBarItem> {

  bool isHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.func,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() { isHover=true; }),
        onExit: (_) => setState(() { isHover=false; }),
        child: AnimatedContainer(
          height: widget.containerSize ?? 40,
          width: widget.containerSize ?? 40,
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.containerSize ?? 40),
            color: isHover ? Colors.grey[200] : Colors.white
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.iconSize ?? 30,
            ),
          ),
        ),
      ),
    );
  }
}