// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10)
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
                        Text(
                          "歌曲Info",
                          style: TextStyle(
                            fontSize: 16
                          ),
                        ),
                        Text(
                          " - 艺人",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3,),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "时间",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
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
                        // TODO 临时参数，需要修改
                        value: c.playProgress.value, 
                        onChanged: (value) => c.updatePlayProgress(value)
                      )
                    )
                  )
                ],
              ),
            ),
            SizedBox(width: 20,),
            GestureDetector(
              child: Icon(
                Icons.favorite_border_outlined,
                size: 20,
              ),
            ),
            SizedBox(width: 25,),
            playMode(),
            SizedBox(width: 15,),
            playBarItem(icon: Icons.skip_previous_rounded, func: operations().preSong),
            SizedBox(width: 5,),
            playBarItem(icon: Icons.pause_rounded, func: operations().toggleSong, iconSize: 35.0, containerSize: 50.0,),
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

  void menuShown(BuildContext context, TapDownDetails details){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    showMenu(
      context: context,
      surfaceTintColor: Colors.white,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ), 
      items: [
        PopupMenuItem(
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => menuShown(context, details),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Icon(
          Icons.repeat_rounded,
          size: 20,
        ),
      ),
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