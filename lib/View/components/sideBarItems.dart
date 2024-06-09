// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/operations.dart';
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: GestureDetector(
        onTap: (){
          c.pageNow.value={
            'index': widget.index,
            'id': '',
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
                  'index': 6,
                  'id': '',
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
                child: Obx(()=>
                  AnimatedContainer(
                    height: 35,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: c.pageNow['index']==6 ? c.color3 : hoverSetting ? c.color2 : c.color1,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.settings_rounded,
                        size: 16,
                      ),
                    ),
                  ),
                )
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

class PlayListPart extends StatefulWidget {
  const PlayListPart({super.key});

  @override
  State<PlayListPart> createState() => _PlayListPartState();
}

class _PlayListPartState extends State<PlayListPart> {

  final Controller c = Get.put(Controller());
  final operations=Operations();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      operations.getAllPlayLists(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Obx(()=>
          ListView.builder(
            itemCount: c.playLists.length,
            itemBuilder: (BuildContext context, int index)=>PlayListItem(name: c.playLists[index]['name'], id: c.playLists[index]['id'])
          )
        )
      ),
    );
  }
}

class PlayListItem extends StatefulWidget {
  final String name;
  final String id;
  const PlayListItem({super.key, required this.name, required this.id});

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {

  bool onHover=false;
  final Controller c = Get.put(Controller());

  Future<void> showPlaylistMenu(BuildContext context, TapDownDetails details) async {
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
        const PopupMenuItem(
          value: "rename",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("重命名")
            ],
          ),
        ),
        const PopupMenuItem(
          value: "del",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("删除")
            ],
          ),
        )
      ]
    );
    if(val=='del'){
      showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('删除歌单'),
          content: const Text('确定要删除这个歌单? 这个操作不可撤销!'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('取消')
            ),
            ElevatedButton(
              onPressed: (){
                Operations().delPlayList(context, widget.id);
                Navigator.pop(context);
              }, 
              child: const Text('删除')
            )
          ],
        )
      );
    }else{
      var newName=TextEditingController();
      showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('重命名歌单'),
          content: TextField(
            controller: newName,
            decoration: InputDecoration(
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10)
            ),
            onEditingComplete: (){
              Operations().renamePlayList(context, widget.id, newName.text);
            },
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
                Operations().renamePlayList(context, widget.id, newName.text);
                Navigator.pop(context);
              }, 
              child: const Text('继续'),
            )
          ],
        )
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: (){
          c.pageNow.value={
            'index': 4,
            'id': widget.id,
          };
        },
        onSecondaryTapDown: (val) => showPlaylistMenu(context, val),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
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
          child: Obx(()=>
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: c.pageNow['index']==4 && c.pageNow['id']==widget.id ? c.color3 :  onHover ? c.color2 : c.color1,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.playlist_play_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 5,),
                    Text(widget.name)
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}