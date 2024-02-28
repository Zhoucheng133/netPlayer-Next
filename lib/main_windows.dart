// ignore_for_file: camel_case_types, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/paras/paras.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'Views/loginView.dart';
import 'Views/mainView.dart';
import 'functions/operations.dart';
import 'functions/request.dart';

class main_windows extends StatefulWidget {
  const main_windows({super.key});

  @override
  State<main_windows> createState() => _main_windowsState();
}

class _main_windowsState extends State<main_windows> with WindowListener {
  final Controller c = Get.put(Controller());
  bool isLogin=false;

  Future<void> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? loginContinue = prefs.getBool('autoLogin');
    if(loginContinue==false){
      c.updateAutoLogin(false);
      setState(() {
        isLoading=false;
      });
      return;
    }

    final String? userInfo = prefs.getString('userInfo');
    if(userInfo!=null){
      Map info=jsonDecode(userInfo);
      var resp = await autoLoginRequest(info['url'], info['username'], info['salt'], info['token']);
      if(resp['status']=='ok'){
        c.updateUserInfo(info);
        setState(() {
          isLoading=false;
        });
      }else{
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text("自动的登录失败"),
            content: Text("你可以尝试重新登录或者重试"),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                  setState(() {
                    isLoading=false;
                  });
                },
                child: Text("重新登录")
              ),
              FilledButton(
                onPressed: (){
                  Navigator.pop(context);
                  autoLogin();
                }, 
                child: Text("重试")
              )
            ],
          )
        );
      }
    }else{
      setState(() {
        isLoading=false;
      });
    }
  }

  Future<void> autoSavePlayInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("playInfo", jsonEncode(c.playInfo));
    prefs.setString("playMode", c.playMode.value);
    prefs.setBool("fullRandom", c.fullRandomPlay.value);

    // 获取歌词
    operations().getLyric();
  }

  Future<void> autoLoadPlayInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? savePlay=prefs.getBool("savePlay");
    if(savePlay==false){
      c.updateSavePlay(false);
      return;
    }

    final String? playInfo=prefs.getString("playInfo");
    final String? playMode=prefs.getString("playMode");
    final bool? fullRandom=prefs.getBool("fullRandom");
    if(playInfo!=null){
      c.updatePlayInfo(jsonDecode(playInfo));
    }
    if(playMode!=null){
      c.updatePlayMode(playMode);
    }
    if(fullRandom!=null){
      c.updateFullRandomPlay(fullRandom);
    }
  }

  bool isLoading=true;

  void isLoginCheck(){
    if(c.userInfo.isEmpty){
      setState(() {
        isLogin=false;
      });
    }else{
      setState(() {
        isLogin=true;
      });
    }
  }

  @override
  void onWindowMaximize(){
    setState(() {
      isMax=true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMax=false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    autoLogin();
    autoLoadPlayInfo();
    ever(c.userInfo, (callback) => isLoginCheck());
    ever(c.playInfo, (callback) => autoSavePlayInfo());
  }

  bool isMax=false;

  void resizeWindow(){
    setState(() {
      isMax=false;
    });
    windowManager.restore();
  }

  void minWindow(){
    windowManager.minimize();
  }

  void maxWindow(){
    setState(() {
      isMax=true;
    });
    windowManager.maximize();
  }

  void closeWindow(){
    windowManager.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => 
          Container(
            color: c.userInfo.isEmpty ? isLoading ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 240, 240, 240) : Color.fromARGB(255, 255, 255, 255),
            child: isLoading ? Container() : c.userInfo.isEmpty ? loginView() : mainView(),
          )
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: DragToMoveArea(
                    child: Container()
                  ),
                ),
                WindowCaptionButton.minimize(
                  onPressed: () => minWindow(),
                ),
                !isMax ?
                WindowCaptionButton.maximize(
                  onPressed: () => maxWindow(),
                ) : WindowCaptionButton.unmaximize(
                  onPressed: () => resizeWindow(),
                ),
                WindowCaptionButton.close(
                  onPressed: () => closeWindow(),
                ),
              ],
            )
          ),
        ),
      ],
    );
  }
}