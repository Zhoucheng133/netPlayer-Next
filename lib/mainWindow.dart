// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:net_player_next/View/mainView.dart';
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
        const Expanded(child: mainView(),)
      ],
    );
  }
}