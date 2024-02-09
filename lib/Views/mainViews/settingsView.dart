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

  @override
  Widget build(BuildContext context) {

    void setSavePlay(val){
      c.updateSavePlay(val);
    }

    void setAutoLogin(val){
      c.updateAutoLogin(val);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(searchController: search, title: "设置", subtitle: "", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 5,),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Obx(() => switchItem(value: c.savePlay.value, text: "自动保存播放的歌曲", setValue: setSavePlay)),
                    Obx(() => switchItem(value: c.autoLogin.value, text: "自动登录", setValue: setAutoLogin))
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