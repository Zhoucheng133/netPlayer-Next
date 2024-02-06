// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

// import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:net_player_next/Views/mainView.dart';

import 'Views/loginView.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
        Obx(() => 
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: c.userInfo.isEmpty ? Color.fromARGB(255, 240, 240, 240) : Colors.white,
            child: c.userInfo.isEmpty ? loginView() : mainView(),
          )
        )
      ],
    );
  }
}
