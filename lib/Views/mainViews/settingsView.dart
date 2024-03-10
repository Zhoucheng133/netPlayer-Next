// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  }

  void setSavePlay(val){
    c.updateSavePlay(val);
  }
  void setAutoLogin(val){
    c.updateAutoLogin(val);
  }

  Future<void> openURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  bool hoverUpdate=false;
  bool hoverClear=false;

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
                          MouseRegion(
                            onEnter: (event) => setState(() { hoverClear=true; }),
                            onExit: (event) => setState(() { hoverClear=false; }),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
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
                    ),
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