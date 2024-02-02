// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:netplayer_next/Views/loginView.dart';

void main() {
  runApp(const MainApp());
  doWhenWindowReady(() {
    const initialSize = Size(1100, 770);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
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
            loginView()
          ],
        )
      ),
    );
  }
}
