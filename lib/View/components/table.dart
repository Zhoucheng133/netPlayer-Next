// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
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
  final dynamic listId;
  final String from;
  final dynamic list;
  final dynamic refresh;
  const songItem({super.key, required this.index, required this.title, required this.duration, required this.isplay, required this.artist, required this.id, this.listId, required this.from, this.list, this.refresh});

  @override
  State<songItem> createState() => _songItemState();
}

class _songItemState extends State<songItem> {
  
  bool hover=false;
  final Controller c = Get.put(Controller());
  final operations=Operations();

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

  Future<void> showSongMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      context: context, 
      color: c.color1,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        PopupMenuItem(
          value: "add",
          enabled: c.playLists.isNotEmpty,
          height: 35,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("添加到歌单...")
            ],
          ),
        ),
        isLoved() ? const PopupMenuItem(
          value: "delove",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.heart_broken_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("取消喜欢")
            ],
          ),
        ) : const PopupMenuItem(
          value: "love",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("喜欢")
            ],
          ),
        ),
        PopupMenuItem(
          value: "del",
          height: 35,
          enabled: widget.listId!=null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_remove_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("从歌单中删除")
            ],
          ),
        ),
      ]
    );
    if(val=='add'){
      String selectItem = c.playLists[0]["id"];
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('添加到歌单...'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return SizedBox(
                height: 200,
                width: 300,
                child: Obx(()=>
                  ListView.builder(
                    itemCount: c.playLists.length,
                    itemBuilder: (BuildContext context, int index){
                      return SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Obx(()=>
                              Radio(
                                value: c.playLists[index]["id"], 
                                // fillColor: c.color6,
                                activeColor: c.color6,
                                groupValue: selectItem, 
                                onChanged: (val){
                                  setState(()=>
                                    selectItem=val
                                  );
                                }
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectItem=c.playLists[index]["id"];
                                });
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Text(
                                  c.playLists[index]["name"]
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  )
                ),
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('取消')
            ),
            ElevatedButton(
              onPressed: (){
                Operations().addToList(context, widget.id, selectItem);
                Navigator.pop(context);
              }, 
              child: const Text('添加')
            )
          ],
        )
      );
    }else if(val=='delove'){
      Operations().deloveSong(context, widget.id);
    }else if(val=='love'){
      Operations().loveSong(context, widget.id);
    }else if(val=='del'){
      if(await operations.delFromList(context, widget.listId, widget.index)){
        widget.refresh();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: (){
        operations.playSong(context, widget.id, widget.title, widget.artist, widget.from, widget.duration, widget.listId??'', widget.index, widget.list??[]);
      },
      onSecondaryTapDown: (val) => showSongMenu(context, val),
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
                  child: widget.isplay ? Icon(
                    Icons.play_arrow_rounded,
                    color: c.color6,
                    size: 15,
                  ) : Text(
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
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.isplay ? c.color6: Colors.black,
                      fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal
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
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.isplay ? c.color6: Colors.black,
                      fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal
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
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.isplay ? c.color6: Colors.black,
                      fontWeight: widget.isplay ? FontWeight.bold : FontWeight.normal
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