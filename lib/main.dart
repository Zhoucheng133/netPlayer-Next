// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/mainView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Views/loginView.dart';
import 'functions/request.dart';
import 'paras/paras.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
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
    }
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
      ],
    );
  }
}
