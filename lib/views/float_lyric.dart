import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class FloatLyric extends StatefulWidget {
  const FloatLyric({super.key});

  @override
  State<FloatLyric> createState() => _FloatLyricState();
}

class _FloatLyricState extends State<FloatLyric> with WindowListener {

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text("FloatLyric"),
        ),
      ),
    );
  }
}