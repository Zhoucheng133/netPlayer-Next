// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:io';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/dialogs.dart';
import 'package:net_player_next/Views/components/settingsItem.dart';
import 'package:net_player_next/functions/operations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../paras/paras.dart';
import '../components/titleBar.dart';

class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {

  final Controller c = Get.put(Controller());

  // 注意！无意义的参数
  TextEditingController searchInput=TextEditingController();

  void reload(){/** 空函数 */}

  bool saveSongPlayed=true;

  TextEditingController controller =TextEditingController();

  String version="";
  
  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
    controller.text=c.userInfo["url"];

    if(Platform.isMacOS){
      getCacheSize();
    }
  }

  void setSavePlay(val){
    c.updateSavePlay(val);
  }
  void setAutoLogin(val){
    c.updateAutoLogin(val);
  }
  void setGlobalShortcut(val){
    c.updateUseGlobalShortcut(val);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${val ? "开启" : "关闭"}全局快捷键'),
          content: Text("重启生效"),
          actions: <Widget>[
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
              }, 
              child: Text("好的")
            ),
          ],
        );
      },
    );
  }
  void setHideOnClose(val){
    c.updateHideOnClose(val);
  }

  Future<void> openURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  bool hoverUpdate=false;
  bool hoverClear=false;

  Future<int> getDirectorySize(Directory path) async {
    int size = 0;
    for (var entity in path.listSync(recursive: true)) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    }
    return size;
  }

  Future<void> clearCache(BuildContext context) async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
      getCacheSize();

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
            Icons.info_outline_rounded,
          ),
          controller: controller, 
          content: Text(
            "清理成功",
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
          backgroundColor: Colors.orange,
          iconColor: Colors.white,
          margin: EdgeInsets.only(
            top: 30,
            left: (MediaQuery.of(context).size.width-280)/2,
            right: (MediaQuery.of(context).size.width-280)/2
          ),
          icon: Icon(
            Icons.info_outline_rounded,
          ),
          controller: controller, 
          content: Text(
            "清理失败",
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
  
  int cacheSize=0;

  Future<void> getCacheSize() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var size = await getDirectorySize(tempDir);
      setState(() {
        cacheSize=size;
      });
    } catch (_) {
      setState(() {
        cacheSize=0;
      });
    }
  }

  String sizeConvert(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(title: "设置", subtitle: "", controller: searchInput, reloadList: () => reload(), searchType: (value) {  },),
          SizedBox(height: 5,),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 400,
                child: Column(
                  children: [
                    Obx(() => switchItem(value: c.savePlay.value, text: "自动保存播放的歌曲", setValue: setSavePlay)),
                    Obx(() => switchItem(value: c.autoLogin.value, text: "自动登录", setValue: setAutoLogin)),
                    Obx(() => switchItem(value: c.hideOnClose.value, text: "关闭后隐藏窗口 (Win)", setValue: setHideOnClose, enableSwitch: Platform.isWindows,)),
                    Obx(() => switchItem(value: c.useGlobalShortcut.value, text: "使用全局快捷键 (Win)", setValue: setGlobalShortcut, enableSwitch: Platform.isWindows, showTip: true,)),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Text("服务器地址")
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              controller: controller,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        SizedBox(width: 160,),
                        FilledButton(
                          onPressed: (){
                            openURL(controller.text);
                          }, 
                          child: Text("用浏览器打开")
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Text("netPlayer版本")
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text("Next v${version}"),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(width: 160),
                          MouseRegion(
                            onEnter: (event) => setState(() { hoverUpdate=true; }),
                            onExit: (event) => setState(() { hoverUpdate=false; }),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                var ltversion=await operations().updateChecker();
                                if(ltversion==""){
                                  showUpdaterErrorDialog(context);
                                }else if("v${version}"==ltversion){
                                  showUpdaterDialog(false, context);
                                }else{
                                  showUpdaterDialog(true, context);
                                }
                              },
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  color: hoverUpdate ? Color.fromARGB(255, 0, 49, 85) : c.primaryColor
                                ),
                                duration: Duration(milliseconds: 200),
                                child: Text("检查更新"),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Platform.isMacOS ?
                    SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Text("歌曲封面缓存")
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            child: Row(
                              children: [
                                Text(sizeConvert(cacheSize))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),
                    Platform.isMacOS ?
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(width: 160),
                          MouseRegion(
                            onEnter: (event) => setState(() { hoverClear=true; }),
                            onExit: (event) => setState(() { hoverClear=false; }),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => clearCache(context),
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  color: hoverClear ? Color.fromARGB(255, 189, 13, 0) : Colors.red,
                                ),
                                duration: Duration(milliseconds: 200),
                                child: Text("清理歌曲封面缓存"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ) : Container()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}