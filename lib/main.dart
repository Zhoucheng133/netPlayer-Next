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
import 'package:net_player_next/views/functions/audio.dart';
import 'package:net_player_next/main_window.dart';
import 'package:net_player_next/variables/variables.dart';
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


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MainTranslations(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('zh', 'TW'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansScTextTheme(),
        splashColor: Colors.transparent,
      ),
      home: const Scaffold(
        body: MainWindow(),
      ),
    );
  }
}