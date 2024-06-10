// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

// TODO 务必注意Item的文字大小为13

class songHeader extends StatefulWidget {
  const songHeader({super.key});

  @override
  State<songHeader> createState() => _songHeaderState();
}

class _songHeaderState extends State<songHeader> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width - 200,
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('序号'),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('标题'),
                )
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('艺人'),
                ),
              ),
              SizedBox(
                width: 70,
                child: Center(
                  child: Icon(
                    Icons.timer_outlined,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Center(
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width - 200,
          decoration: BoxDecoration(
            color: c.color4,
            borderRadius: BorderRadius.circular(2)
          ),
        )
      ],
    );
  }
}

class artistHeader extends StatefulWidget {
  const artistHeader({super.key});

  @override
  State<artistHeader> createState() => _artistHeaderState();
}

class _artistHeaderState extends State<artistHeader> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width - 200,
          child: const Row(
            children: [
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('序号'),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('标题'),
                )
              ),
              SizedBox(
                width: 100,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('专辑数量')
                ),
              )
            ],
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width - 200,
          decoration: BoxDecoration(
            color: c.color4,
            borderRadius: BorderRadius.circular(2)
          ),
        )
      ],
    );
  }
}

class albumHeader extends StatefulWidget {
  const albumHeader({super.key});

  @override
  State<albumHeader> createState() => _albumHeaderState();
}

class _albumHeaderState extends State<albumHeader> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width - 200,
          child: const Row(
            children: [
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('序号'),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('专辑名称'),
                )
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('艺人')
                ),
              ),
              SizedBox(
                width: 100,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('歌曲数')
                ),
              )
            ],
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width - 200,
          decoration: BoxDecoration(
            color: c.color4,
            borderRadius: BorderRadius.circular(2)
          ),
        )
      ],
    );
  }
}

class songItem extends StatefulWidget {
  final int index;
  final String title;
  final int duration;
  final String id;
  final bool isplay;
  final String artist;
  const songItem({super.key, required this.index, required this.title, required this.duration, required this.isplay, required this.artist, required this.id});

  @override
  State<songItem> createState() => _songItemState();
}

class _songItemState extends State<songItem> {
  
  bool hover=false;
  final Controller c = Get.put(Controller());

  String convertDuration(int time){
    int min = time ~/ 60;
    int sec = time % 60;
    String formattedSec = sec.toString().padLeft(2, '0');
    return "$min:$formattedSec";
  }

  bool isLoved(){
    for (var val in c.lovedSongs) {
      if(val["id"]==widget.id){
        return true;
      }
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        onEnter: (_){
          setState(() {
            hover=true;
          });
        },
        onExit: (_){
          setState(() {
            hover=false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: hover ?  c.color1: Colors.white,
          height: 40,
          width: MediaQuery.of(context).size.width - 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    (widget.index+1).toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                )
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.artist,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: Center(
                  child: Text(
                    convertDuration(widget.duration),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  )
                ),
              ),
              SizedBox(
                width: 50,
                child: Center(
                  child: Obx(()=>
                    isLoved() ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 16,
                    ) : Container(),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}