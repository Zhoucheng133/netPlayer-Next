// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously, unrelated_type_equality_checks, camel_case_types
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/functions/audio.dart';
import 'package:net_player_next/mainWindow.dart';
import 'package:window_manager/window_manager.dart';

import 'paras/paras.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  MediaKit.ensureInitialized();
  await hotKeyManager.unregisterAll();
  final Controller c = Get.put(Controller());

  c.handler=await AudioService.init(
    builder: () => audioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.zhouc.netPlayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );

  

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'US'), // 美国英语
        Locale('zh', 'CN'), // 中文简体
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: "Noto",
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: Scaffold(
        body: main_window()
      ),
    );
  }
}