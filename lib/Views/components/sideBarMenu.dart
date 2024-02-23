// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/operations.dart';

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
      var val=await operations().delList(widget.id);
      if(val){
        showFlash(
          duration: const Duration(milliseconds: 1500),
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200), 
          builder: (context, controller) => FlashBar(
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            backgroundColor: Colors.green[400],
            iconColor: Colors.white,
            margin: EdgeInsets.only(
              top: 30,
              left: (MediaQuery.of(context).size.width-280)/2,
              right: (MediaQuery.of(context).size.width-280)/2
            ),
            icon: Icon(
              Icons.done,
            ),
            controller: controller, 
            content: Text(
              "删除成功!",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          context: context
        );
      }else{
        showFlash(
          duration: const Duration(milliseconds: 1500),
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200), 
          builder: (context, controller) => FlashBar(
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            backgroundColor: Colors.red,
            iconColor: Colors.white,
            margin: EdgeInsets.only(
              top: 30,
              left: (MediaQuery.of(context).size.width-280)/2,
              right: (MediaQuery.of(context).size.width-280)/2
            ),
            icon: Icon(
              Icons.done,
            ),
            controller: controller, 
            content: Text(
              "删除失败!",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          context: context
        );
      }
    }else if(val=="rename"){
      // operations().renameList(widget.id, newName)
      reNameList(context);
    }
  }

  FocusNode textfocus=FocusNode();

  @override
  void initState() {
    super.initState();

    textfocus.addListener(() { 
      if(textfocus.hasFocus){
        c.updateFocusTextField(true);
      }else{
        c.updateFocusTextField(false);
      }
    });
  }

  Future<void> reNameList(BuildContext context) async {
    var controller=TextEditingController();

    await showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text("重命名歌单"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("歌单名称:"),
            SizedBox(height: 10,),
            TextField(
              focusNode: textfocus,
              controller: controller,
              style: TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: c.hoverColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 210, 210, 210),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text("取消")
          ),
          FilledButton(
            onPressed: () {
              if(controller.text==""){
                showFlash(
                  duration: const Duration(milliseconds: 1500),
                  transitionDuration: const Duration(milliseconds: 200),
                  reverseTransitionDuration: const Duration(milliseconds: 200), 
                  builder: (context, controller) => FlashBar(
                    behavior: FlashBehavior.floating,
                    position: FlashPosition.top,
                    backgroundColor: Colors.red,
                    iconColor: Colors.white,
                    margin: EdgeInsets.only(
                      top: 30,
                      left: (MediaQuery.of(context).size.width-280)/2,
                      right: (MediaQuery.of(context).size.width-280)/2
                    ),
                    icon: Icon(
                      Icons.close,
                    ),
                    controller: controller, 
                    content: Text(
                      "歌单名称不能为空",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  context: context
                );
              }else{
                // operations().renameList(widget.id, controller.text);
                renameController(controller.text);
                Navigator.pop(context);
              }
            }, 
            child: Text("完成")
          )
        ],
      )
    );
  }

  Future<void> renameController(String newName) async {
    var val=await operations().renameList(widget.id, newName);
    if(val){
      showFlash(
        duration: const Duration(milliseconds: 1500),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200), 
        builder: (context, controller) => FlashBar(
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          backgroundColor: Colors.green[400],
          iconColor: Colors.white,
          margin: EdgeInsets.only(
            top: 30,
            left: (MediaQuery.of(context).size.width-280)/2,
            right: (MediaQuery.of(context).size.width-280)/2
          ),
          icon: Icon(
            Icons.done,
          ),
          controller: controller, 
          content: Text(
            "修改成功",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        context: context
      );
    }else{
      showFlash(
        duration: const Duration(milliseconds: 1500),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200), 
        builder: (context, controller) => FlashBar(
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          backgroundColor: Colors.red,
          iconColor: Colors.white,
          margin: EdgeInsets.only(
            top: 30,
            left: (MediaQuery.of(context).size.width-280)/2,
            right: (MediaQuery.of(context).size.width-280)/2
          ),
          icon: Icon(
            Icons.close,
          ),
          controller: controller, 
          content: Text(
            "修改失败",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        context: context
      );
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