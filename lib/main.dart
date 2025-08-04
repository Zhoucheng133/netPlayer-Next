import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:net_player_next/lang/en_us.dart';
import 'package:net_player_next/lang/zh_cn.dart';
import 'package:net_player_next/lang/zh_tw.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/functions/audio.dart';
import 'package:net_player_next/main_window.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
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
  Get.put(SongController());
  Get.put(ColorController(themeColor==null ? null : Color(themeColor), darkMode, autoDark));
  c.handler=await AudioService.init(
    builder: () => audioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'zhouc.netPlayer.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MainApp());
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

    return Obx(()=>
      GetMaterialApp(
        translations: MainTranslations(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
        ],
        theme: colorController.darkMode.value ? ThemeData.dark().copyWith(
          textTheme: GoogleFonts.notoSansScTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white, 
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorController.baseColor.value,
            brightness: Brightness.dark,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: colorController.color1(),
          )
        ) : ThemeData(
          splashColor: Colors.transparent,
          primaryColor: colorController.baseColor.value,
          colorScheme: ColorScheme.fromSeed(seedColor: colorController.baseColor.value),
          textTheme: GoogleFonts.notoSansScTextTheme(),
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