import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/lang/en_us.dart';
import 'package:net_player_next/lang/zh_cn.dart';
import 'package:net_player_next/lang/zh_tw.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/playlist_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/float_lyric/float_lyric.dart';
import 'package:net_player_next/views/float_lyric/style_var.dart' hide LanguageType, supportedLocales;
import 'package:net_player_next/views/functions/audio.dart';
import 'package:net_player_next/main_window.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final windowController = await WindowController.fromCurrentEngine();
  final windowArgs=windowController.arguments;
  await windowManager.ensureInitialized();
  if(windowArgs=="lyric"){
    final StyleVar styleVar=Get.put(StyleVar());
    await styleVar.initPrefs();
    await styleVar.initLang();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(600, 130),
      minimumSize: const Size(600, 130),
      center: styleVar.positionX.value==0.0 && styleVar.positionY.value==0.0 ? true : false,
      backgroundColor: Colors.transparent,
      skipTaskbar: Platform.isWindows,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Lyric',
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async{
      await windowManager.setResizable(false);
      await windowManager.setAsFrameless();
      if(styleVar.alwaysOnTop.value){
        await windowManager.setAlwaysOnTop(true);
      }
      if(!styleVar.showShadow.value){
        await windowManager.setHasShadow(false);
      }
      if(styleVar.positionX.value!=0.0 && styleVar.positionY.value!=0.0){
        await windowManager.setPosition(Offset(styleVar.positionX.value, styleVar.positionY.value));
      }else{
        await windowManager.center();
      }
    });
    runApp(const FloatLyric());
  }else{
    MediaKit.ensureInitialized();
    await hotKeyManager.unregisterAll();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(900, 650),
      minimumSize: Size(900, 650),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'netPlayer'
    );
    final Controller c = Get.put(Controller());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeColor=prefs.getInt("theme");
    final darkMode=prefs.getBool("darkMode");
    final autoDark=prefs.getBool("autoDark");
    c.wakeLockLyric.value=prefs.getBool("wakeLockLyric")??true;
    Get.put(SongController());
    Get.put(PlaylistController());
    Get.put(ColorController(themeColor==null ? null : Color(themeColor), darkMode, autoDark));

    c.handler=await AudioService.init(
      builder: () => MainAudioHanlder(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'zhouc.netPlayer.channel.audio',
        androidNotificationChannelName: 'Music playback',
      ),
    );
    await c.initLang();
    await windowManager.waitUntilReadyToShow(windowOptions);
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.focus();
    // });
    runApp(const MainApp());
  }
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
  };
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    colorController.autoDarkMode(brightness == Brightness.dark);

    final Controller c = Get.find();

    return Obx(()=>
      GetMaterialApp(
        translations: MainTranslations(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        locale: c.lang.value.locale, 
        supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
        fallbackLocale: supportedLocales[0].locale,
        theme: ThemeData(
          brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
          fontFamily: 'PuHui', 
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorController.baseColor.value,
            brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
          ),
          textTheme: colorController.darkMode.value ? ThemeData.dark().textTheme.apply(
            fontFamily: 'PuHui',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme.apply(
            fontFamily: 'PuHui',
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: colorController.color1(),
          )
        ),
        home: const Scaffold(
          body: MainWindow(),
        ),
      )
    );
  }
}