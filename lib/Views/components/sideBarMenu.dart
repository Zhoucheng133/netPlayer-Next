// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../paras/paras.dart';

class sideBarMenu extends StatefulWidget {
  final String menuName;
  final IconData menuIcon;
  final bool selected;
  final ValueChanged changePage;
  final dynamic id;

  const sideBarMenu({super.key, required this.menuName, required this.menuIcon, required this.selected, required this.changePage, this.id});

  @override
  State<sideBarMenu> createState() => _sideBarMenuState();
}

class _sideBarMenuState extends State<sideBarMenu> {

  bool isHover=false;
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.id!=null){
          widget.changePage({
            "name": "歌单",
            "id": widget.id,
          });
          c.updateSelectedListName(widget.menuName);
        }else{
          widget.changePage({
            "name": widget.menuName,
            "id": null,
          });
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() { isHover=true; }),
        onExit: (event) => setState(() { isHover=false; }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:widget.selected ? Color.fromARGB(255, 230, 230, 230) : isHover ? Color.fromARGB(255, 220, 220, 220) : Color.fromARGB(0, 220, 220, 220)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 10, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.menuIcon,
                  size: widget.menuIcon==Icons.playlist_play_rounded ? 20 : 18,
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text(
                    widget.menuName,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class sideBarMini extends StatefulWidget {
  final IconData icon;
  final VoidCallback func;
  final bool isSelected;

  const sideBarMini({super.key, required this.icon, required this.func, required this.isSelected});

  @override
  State<sideBarMini> createState() => _sideBarMiniState();
}

class _sideBarMiniState extends State<sideBarMini> {

  bool isHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.func(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() { isHover=true; }),
        onExit: (event) => setState(() { isHover=false; }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isHover ? Color.fromARGB(255, 220, 220, 220) : Color.fromARGB(0, 220, 220, 220)
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Icon(
                widget.icon,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class aboutTextButton extends StatefulWidget {

  final VoidCallback toAbout;

  const aboutTextButton({super.key, required this.toAbout});

  @override
  State<aboutTextButton> createState() => _aboutTextButtonState();
}

class _aboutTextButtonState extends State<aboutTextButton> {

  final Controller c = Get.put(Controller());

  bool isHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.toAbout(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() { isHover=true; }),
        onExit: (event) => setState(() { isHover=false; }),
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 14,
            color: isHover ? c.hoverColor : Colors.grey[400],
          ),
          child: Text(
            "关于 netPlayer",
          ),
        ),
      ),
    );
  }
}

class playListMenu extends StatefulWidget {
  final String menuName;
  final IconData menuIcon;
  final bool selected;
  final ValueChanged changePage;
  final dynamic id;

  const playListMenu({super.key, required this.menuName, required this.menuIcon, required this.selected, required this.changePage, this.id});

  @override
  State<playListMenu> createState() => _playListMenu();
}

class _playListMenu extends State<playListMenu> {

  bool isHover=false;
  final Controller c = Get.put(Controller());

  Future<void> showPlaylistMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
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
        PopupMenuItem(
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
    if(val=="del"){
      // TODO 删除歌单
    }else if(val=="rename"){
      // TODO 重命名歌单
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.id!=null){
          widget.changePage({
            "name": "歌单",
            "id": widget.id,
          });
          c.updateSelectedListName(widget.menuName);
        }else{
          widget.changePage({
            "name": widget.menuName,
            "id": null,
          });
        }
      },
      onSecondaryTapDown: (val) => showPlaylistMenu(context, val),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() { isHover=true; }),
        onExit: (event) => setState(() { isHover=false; }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:widget.selected ? Color.fromARGB(255, 230, 230, 230) : isHover ? Color.fromARGB(255, 220, 220, 220) : Color.fromARGB(0, 220, 220, 220)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 10, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.menuIcon,
                  size: widget.menuIcon==Icons.playlist_play_rounded ? 20 : 18,
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text(
                    widget.menuName,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}