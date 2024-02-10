// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:net_player_next/functions/operations.dart';

class songItem extends StatefulWidget {

  final int index;
  final String title;
  final String artist;
  final int duration;
  final bool isLoved;
  final VoidCallback playSong;
  final dynamic id;

  const songItem({super.key, required this.index, required this.title, required this.artist, required this.duration, required this.isLoved, required this.playSong, this.id,});

  @override
  State<songItem> createState() => _songItemState();
}

class _songItemState extends State<songItem> {
  bool isHover=false;

  void menuShow(BuildContext context, TapDownDetails details){
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
      items: <PopupMenuEntry>[
        PopupMenuItem(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("播放")
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
                Icons.playlist_add_rounded,
                size: 16,
              ),
              SizedBox(width: 5,),
              Text("添加到歌单")
            ],
          ),
        ),
        widget.isLoved ?
        PopupMenuItem(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.heart_broken_rounded,
                size: 14,
              ),
              SizedBox(width: 5,),
              Text("取消喜欢")
            ],
          ),
        ):
        PopupMenuItem(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 14,
              ),
              SizedBox(width: 5,),
              Text("喜欢")
            ],
          ),
        ),
        PopupMenuItem(
          height: 35,
          enabled: widget.id!=null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 14,
              ),
              SizedBox(width: 5,),
              Text("从歌单中删除")
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (val) => menuShow(context, val),
      onDoubleTap: () => widget.playSong(),
      child: MouseRegion(
        onEnter: (_)=>setState(() {isHover=true;}),
        onExit: (_)=>setState(() {isHover=false;}),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: isHover ? Color.fromARGB(255, 240, 240, 240) : Colors.white,
          child: SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text((widget.index+1).toString()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.artist,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ),
                SizedBox(
                  width: 70,
                  child: Center(
                    child: Text(operations().timeConvert(widget.duration)),
                  )
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: widget.isLoved ? Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 18,
                    ) : Container()
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTapDown: (val) => menuShow(context, val),
                    child: Container(
                      color: Colors.transparent,
                      width: 50,
                      child: Center(
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}