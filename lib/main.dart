// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/mainView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/loginView.dart';
import 'functions/request.dart';
import 'paras/paras.dart';

void main() {
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
    return FluentApp(
      home: MainApp(),
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

  Future<void> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userInfo = prefs.getString('userInfo');
    if(userInfo!=null){
      Map info=jsonDecode(userInfo);
      var resp = await autoLoginRequest(info['url'], info['username'], info['salt'], info['token']);
      print(resp);
      if(resp['status']=='ok'){
        c.updateUserInfo(info);
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  bool isLoading=true;
  
  @override
  void initState() {
    super.initState();

    autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() => 
          Container(
            color: c.userInfo.isEmpty ? isLoading ? Colors.white : Color.fromARGB(255, 240, 240, 240) : Colors.white,
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
      ],
    );
  }
}
