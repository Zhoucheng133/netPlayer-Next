// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';

class SideBarItem extends StatefulWidget {
  final String name;
  final IconData icon;
  final int index;

  const SideBarItem({super.key, required this.name, required this.icon, required this.index});

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {

  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  bool onHover=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: GestureDetector(
        onTap: (){
          c.pageIndex.value=widget.index;
          c.pageId.value='';
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
                color: c.pageIndex.value==widget.index ? colorController.color3() :  onHover ? colorController.color2() : colorController.color1(),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 16,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      widget.name,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    )
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

class PlayListLabel extends StatefulWidget {
  final VoidCallback addPlayListHandler;
  const PlayListLabel({super.key, required this.addPlayListHandler});

  @override
  State<PlayListLabel> createState() => _PlayListLabelState();
}

class _PlayListLabelState extends State<PlayListLabel> {

  final Controller c = Get.find();
  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
          child: Obx(()=>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('playLists'.tr, style: GoogleFonts.notoSansSc(
                  fontSize: 13,
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),),
                GestureDetector(
                  onTap: (){
                    widget.addPlayListHandler();
                  },
                  child: Tooltip(
                    message: 'addPlayList'.tr,
                    waitDuration: const Duration(seconds: 1),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: colorController.darkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Obx(()=>
            Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: colorController.color3()
              ),
            ),
          )
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

  final Controller c = Get.find();
  final ColorController colorController=Get.find();

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
                c.pageIndex.value=6;
                c.pageId.value='';
              },
              child: Tooltip(
                message: 'settings'.tr,
                waitDuration: const Duration(seconds: 1),
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
                        color: c.pageIndex.value==6 ? colorController.color3() : hoverSetting ? colorController.color2() : colorController.color1(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.settings_rounded,
                          size: 16,
                          color: colorController.darkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  )
                ),
              ),
            )
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                widget.logoutHandler();
              },
              child: Tooltip(
                message: 'logout'.tr,
                waitDuration: const Duration(seconds: 1),
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
                  child: Obx(()=>
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: hoverLogout ? colorController.color2() : colorController.color1(),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.logout_rounded,
                          size: 16,
                          color: colorController.darkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
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

  final Controller c = Get.find();
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
  final Controller c = Get.find();
  Operations operations=Operations();
  final ColorController colorController=Get.find();

  Future<void> showPlaylistMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      context: context, 
      color: colorController.darkMode.value ? colorController.color3() : Colors.white,
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
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                "rename".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
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
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                "delete".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: "info",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.info_rounded,
                size: 18,
                color: colorController.darkMode.value ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 5,),
              Text(
                "playlistInfo".tr,
                style: GoogleFonts.notoSansSc(
                  color: colorController.darkMode.value ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        )
      ]
    );
    if(val=='del'){
      showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('deletePlayList'.tr),
          content: Text('deletePlayListContent'.tr),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('cancel'.tr)
            ),
            ElevatedButton(
              onPressed: (){
                operations.delPlayList(context, widget.id);
                Navigator.pop(context);
              }, 
              child: Text('delete'.tr)
            )
          ],
        )
      );
    }else if(val=='rename'){
      var newName=TextEditingController();
      showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('rename'.tr),
          content: TextField(
            controller: newName,
            decoration: InputDecoration(
              hintText: widget.name,
              hintStyle: TextStyle(
                color: Colors.grey[400]
              ),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorController.color4().withAlpha(100), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorController.color5(), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            ),
            onEditingComplete: (){
              operations.renamePlayList(context, widget.id, newName.text);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('cancel'.tr)
            ),
            ElevatedButton(
              onPressed: (){
                operations.renamePlayList(context, widget.id, newName.text);
                Navigator.pop(context);
              }, 
              child: Text('finish'.tr),
            )
          ],
        )
      );
    }else if(val=='info'){
      // print(widget.id);
      var getList=await operations.getPlayListInfo(context, widget.id);
      if(getList.isEmpty){
        return;
      }
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text('playlistInfo'.tr, style: GoogleFonts.notoSansSc(),),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${getList['id']}",
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'playListName'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: (){
                            FlutterClipboard.copy(getList['name']).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          },
                          child: Text(
                            getList['name'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'playListCount'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        getList['songCount'].toString(),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'totalDuration'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operations.convertDuration(getList['duration']),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'playlistId'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: (){
                            FlutterClipboard.copy(getList['id']).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          },
                          child: Text(
                            getList['id'],
                            maxLines: 2,
                          ),
                        ),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'created'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operations.formatIsoString(getList['created']),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'changed'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operations.formatIsoString(getList['changed']),
                      )
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: ()=>Navigator.pop(context), 
              child: Text("ok".tr, style: GoogleFonts.notoSansSc(),)
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
          c.pageIndex.value=4;
          c.pageId.value=widget.id;
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
                color: c.pageIndex.value==4 && c.pageId.value==widget.id ? colorController.color3() :  onHover ? colorController.color2() : colorController.color1(),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.playlist_play_rounded,
                      size: 16,
                      color: colorController.darkMode.value ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: AutoSizeText(
                        widget.name,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 14,
                          color: colorController.darkMode.value ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        minFontSize: 12,
                        maxFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
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