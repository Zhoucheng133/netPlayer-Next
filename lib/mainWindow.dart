// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/requests.dart';
import 'package:net_player_next/View/mainView.dart';
import 'package:net_player_next/View/mainViews/login.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    ever(c.userInfo, (callback)=>setLogin());
    initPref();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize(){
    setState(() {
      isMax=true;
    });
  }

  @override
  void onWindowUnmaximize(){
    setState(() {
      isMax=false;
    });
  }

  bool isMax=false;
  
  void minWindow(){
    windowManager.minimize();
  }
  void maxWindow(){
    windowManager.maximize();
  }
  void closeWindow(){
    windowManager.close();
  }
  void unmaxWindow(){
    windowManager.unmaximize();
  }


  final Controller c = Get.put(Controller());
  var isLogin=false;
  var isLoading=true;

  void setLogin(){
    if(c.userInfo['username']!=null){
      setState(() {
        isLogin=true;
      });
    }else{
      setState(() {
        isLogin=false;
      });
    }
  }
  
  Future<void> initPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final autoLogin=prefs.getBool('autoLogin');

    if(autoLogin==false){
      c.autoLogin.value=false;
      setState(() {
        isLoading=false;
      });
      return;
    }


    final userInfo=prefs.getString('userInfo');
    if(userInfo!=null){
      final userData=jsonDecode(userInfo);
      final requests=HttpRequests();
      final rlt=await requests.loginRequest(userData['url'], userData['username'], userData['salt'], userData['token']);
      if(rlt.isEmpty){
        WidgetsBinding.instance.addPostFrameCallback((_){
          showDialog(
            context: context, 
            builder: (BuildContext context)=>AlertDialog(
              title: const Text('登录失败'),
              content: const Text('网络请求失败，请检查你的网络和服务器运行状态'),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text('好的')
                )
              ],
            ),
          );
        });
        return;
      }else if(rlt['status']=='failed'){
        WidgetsBinding.instance.addPostFrameCallback((_){
          showDialog(
            context: context, 
            builder: (BuildContext context)=>AlertDialog(
              title: const Text('登录失败'),
              content: const Text('用户名或者密码错误'),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: const Text('好的')
                )
              ],
            ),
          );
        });
        return;
      }
      c.userInfo.value={
        'url': userData['url'],
        'username': userData['username'],
        'salt': userData['salt'],
        'token': userData['token'],
      };
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.transparent,
          child: Platform.isWindows ? Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              WindowCaptionButton.minimize(onPressed: minWindow,),
              isMax ? WindowCaptionButton.unmaximize(onPressed: unmaxWindow) : WindowCaptionButton.maximize(onPressed: maxWindow,),
              WindowCaptionButton.close(onPressed: closeWindow,)
            ],
          ) : DragToMoveArea(child: Container())
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLoading ? const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text('加载中...'),
              ),
            ) : isLogin ? const mainView() : const loginView(),
          ),
        )
      ],
    );
  }
}