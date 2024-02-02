// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: WindowTitleBarBox(
                  child: MoveWindow(),
                ),
              ),
            ),
            // Column(
            //   children: [
            //     Text("hello world!")
            //   ],
            // )
            Positioned(
              top: 0,
              left: 0,
              child: Text("hello world!")
            )
          ],
        )
      ),
    );
  }
}
