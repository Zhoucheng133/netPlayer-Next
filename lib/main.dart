// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously, unrelated_type_equality_checks, camel_case_types

import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/audio.dart';
import 'package:net_player_next/main_macos.dart';
import 'package:net_player_next/main_windows.dart';
import 'package:window_manager/window_manager.dart';

import 'paras/paras.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isWindows){
    await windowManager.ensureInitialized();
  }
  await hotKeyManager.unregisterAll();
  final Controller c = Get.put(Controller());
  c.handler=await AudioService.init(
    builder: () => audioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.zhouc.netPlayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  if(Platform.isWindows){
    WindowOptions windowOptions = WindowOptions(
      size: Size(1100, 770),
      center: true,
      minimumSize: Size(1100, 770),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: "netPlayer"
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  if(Platform.isMacOS){
    doWhenWindowReady(() {
      const initialSize = Size(1100, 770);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: "Noto",
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Scaffold(
        body: Platform.isMacOS ? main_macos() : main_windows(),
      ),
    );
  }
}