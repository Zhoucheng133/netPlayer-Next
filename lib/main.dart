// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/mainView.dart';
import 'package:net_player_next/functions/audio.dart';
import 'package:net_player_next/functions/operations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/loginView.dart';
import 'functions/request.dart';
import 'paras/paras.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();
  final Controller c = Get.put(Controller());
  c.handler=await AudioService.init(
    builder: () => audioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.zhouc.netPlayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  runApp(MyApp());
  doWhenWindowReady(() {
    appWindow.minSize = Size(1100, 770);
    appWindow.size = Size(1100, 770);
    appWindow.alignment = Alignment.center;
    appWindow.title="netPlayer Next";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: "Noto",
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Scaffold(
        body: MainApp(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

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
  void initState() {
    super.initState();

    autoLogin();
    autoLoadPlayInfo();
    ever(c.userInfo, (callback) => isLoginCheck());
    ever(c.playInfo, (callback) => autoSavePlayInfo());
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
            child: WindowTitleBarBox(
              child: MoveWindow(),
            ),
          ),
        ),
        if(Platform.isMacOS) PlatformMenuBar(
          menus: [
            PlatformMenu(
              label: "netPlayer", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "关于 netPlayer",
                      onSelected: isLogin ? (){
                        c.updateNowPage({
                          "name": "关于",
                          "id": "",
                        });
                      } : null
                    )
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "设置...",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.comma,
                        meta: true,
                      ),
                      onSelected: isLogin ? () => c.updateNowPage({
                        "name": "设置",
                        "id": "",
                      }) : null
                    ),
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.hide,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.quit,
                    ),
                  ]
                )
              ]
            ),
            PlatformMenu(
              label: "编辑",
              menus: [
                PlatformMenuItem(
                  label: "拷贝",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyC,
                    meta: true
                  ),
                  onSelected: (){}
                ),
                PlatformMenuItem(
                  label: "粘贴",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyV,
                    meta: true
                  ),
                  onSelected: (){}
                ),
                PlatformMenuItem(
                  label: "全选",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyA,
                    meta: true
                  ),
                  onSelected: (){}
                )
              ]
            ),
            PlatformMenu(
              label: "操作", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "暂停/播放",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.space,
                      ),
                      onSelected: (){},
                    ),
                    PlatformMenuItem(
                      label: "上一首",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.arrowLeft,
                        meta: true,
                      ),
                      onSelected: ()=>operations().preSong(),
                    ),
                    PlatformMenuItem(
                      label: "下一首",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.arrowRight,
                        meta: true,
                      ),
                      onSelected: ()=>operations().nextSong(),
                    )
                  ]
                )
              ]
            ),
            PlatformMenu(
              label: "窗口", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.minimizeWindow,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.toggleFullScreen,
                    )
                  ]
                )
              ]
            )
          ]
        ),
      ],
    );
  }
}
