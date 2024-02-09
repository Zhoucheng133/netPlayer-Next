// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/components/settingsItem.dart';

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

  void search(val){ /** 空函数 */}

  bool saveSongPlayed=true;

  TextEditingController controller =TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text=c.userInfo["url"];
  }

  void setSavePlay(val){
    c.updateSavePlay(val);
  }
  void setAutoLogin(val){
    c.updateAutoLogin(val);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(searchController: search, title: "设置", subtitle: "", controller: searchInput, reloadList: () => reload(),),
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
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
                          ),
                        ],
                      ),
                    )
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