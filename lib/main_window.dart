import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/variables/lyric_controller.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:net_player_next/views/main_view.dart';
import 'package:net_player_next/views/main_views/login.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener, TrayListener  {

  late Worker listener;
  late Worker wsOkListener;
  Operations operations=Operations();
  final ColorController colorController=Get.find();

  @override
  void onWindowClose() {
    c.ws.closeKit();
    super.onWindowClose();
  }

  @override
  void onWindowResized(){
    if(c.showLyric.value){
      try {
        LyricController lyricController=Get.find();
        lyricController.scrollLyric();
      } catch (_) {}
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    trayManager.addListener(this);
    initMenuIcon();
    listener=ever(c.userInfo, (callback)=>setLogin());
    wsOkListener=ever(c.wsOk, (callback){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(!c.wsOk.value){
          showDialog(
            context: context, 
            builder: (BuildContext context)=>AlertDialog(
              title: Text('wsFailedTitle'.tr),
              content: Text('wsFailedContent'.tr),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text('ok'.tr)
                )
              ],
            )
          );
        }
      });
      
    });
     WidgetsBinding.instance.addPostFrameCallback((_){
      initPref(context);
    });
    
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    listener.dispose();
    wsOkListener.dispose();
    // c.ws.stop();
    try {
      c.ws.stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  void onWindowMaximize(){
    c.maxWindow.value=true;
    if(c.showLyric.value){
      try {
        Future.delayed(const Duration(milliseconds: 300), (){
          LyricController lyricController=Get.find();
          lyricController.scrollLyric();
        });
      } catch (_) {}
    }
  }

  @override
  void onWindowUnmaximize(){
    c.maxWindow.value=false;
    if(c.showLyric.value){
      try {
        Future.delayed(const Duration(milliseconds: 300), (){
          LyricController lyricController=Get.find();
          lyricController.scrollLyric();
        });
      } catch (_) {}
    }
  }

  Future<void> initMenuIcon() async {
    await trayManager.setIcon(
      Platform.isWindows ? "assets/ico.ico" : "assets/icon.png"
    );
    Menu menu = Menu(
      items: [
        MenuItem(
          key: "toggle",
          label: "play/pause".tr
        ),
        MenuItem(
          key: "previous_song",
          label: "skipPre".tr
        ),
        MenuItem(
          key: "next_song",
          label: "skipNext".tr,
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: 'exit'.tr,
        ),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    if(Platform.isMacOS){
      trayManager.popUpContextMenu();
    }else{
      windowManager.show();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    if(Platform.isWindows){
      trayManager.popUpContextMenu();
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if(menuItem.key == 'exit_app') {
      windowManager.close();
    }else if(menuItem.key == 'toggle'){
      operations.toggleSong();
    }else if(menuItem.key=="next_song"){
      operations.skipNext();
    }else if(menuItem.key=="previous_song"){
      operations.skipPre();
    }
  }

  void minWindow(){
    windowManager.minimize();
  }
  void maxWindow(){
    windowManager.maximize();
  }
  
  void unmaxWindow(){
    windowManager.unmaximize();
  }


  final Controller c = Get.find();
  var isLogin=false;
  var isLoading=true;

  void setLogin(){
    if(c.userInfo.value.username!=null){
      setState(() {
        isLogin=true;
      });
    }else{
      setState(() {
        isLogin=false;
      });
    }
  }
  
  Future<void> initPref(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final lang=prefs.getString('lang');
    if(lang!=null){
      var parts = lang.split('_');
      c.lang.value=lang;
      var locale=Locale(parts[0], parts[1]);
      Get.updateLocale(locale);
    }else{
      if(context.mounted){
        Locale locale = Localizations.localeOf(context);
        String countryCode = locale.countryCode ?? '';
        switch (countryCode) {
          case 'US':
          case 'CN':
          case 'TW':
            Get.updateLocale(locale);
            c.lang.value="${locale.languageCode}_${locale.countryCode}";
            break;
          default:
            Get.updateLocale(const Locale('zh', 'CN'));
            c.lang.value="zh_CN";
        }
      }
    }


    final autoLogin=prefs.getBool('autoLogin');

    if(autoLogin==false){
      c.autoLogin.value=false;
      setState(() {
        isLoading=false;
      });
      return;
    }

    final lyricTranslate=prefs.getBool('lyricTranslate');

    if(lyricTranslate==false){
      c.lyricTranslate.value=false;
    }


    final userInfo=prefs.getString('userInfo');
    if(userInfo!=null){
      final userData=jsonDecode(userInfo);
      final requests=HttpRequests();
      final rlt=await requests.loginRequest(userData['url'], userData['username'], userData['salt'], userData['token']);
      if(rlt.isEmpty && context.mounted){
        await showDialog(
          context: context, 
          builder: (BuildContext context)=>AlertDialog(
            title: Text('loginFail'.tr),
            content: Text('loginConnectFail'.tr),
            actions: [
              ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                child: Text('ok'.tr)
              )
            ],
          ),
        );
        setState(() {
          isLoading=false;
        });
        return;
      }else if(rlt['subsonic-response']['status']=='failed'){
        WidgetsBinding.instance.addPostFrameCallback((_){
          showDialog(
            context: context, 
            builder: (BuildContext context)=>AlertDialog(
              title: Text('loginFail'.tr),
              content: Text('passwordErr'.tr),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      isLoading=false;
                    });
                    Navigator.pop(context);
                  }, 
                  child: Text('ok'.tr)
                )
              ],
            ),
          );
        });
        return;
      }
      bool? useNavidrome=prefs.getBool("useNavidrome");
      c.useNavidromeAPI.value=useNavidrome??true;
      // 从旧版本更新
      if((userData['password']==null || userData['password'].isEmpty) && useNavidrome!=false && context.mounted){
        bool enableNavidrome=true;
        await showDialog(
          context: context, 
          builder: (BuildContext context)=>AlertDialog(
            title: Text('useNavidromeAPI'.tr),
            content: Text('enableNavidromeContent'.tr),
            actions: [
              TextButton(
                onPressed: (){
                  enableNavidrome=false;
                  Navigator.pop(context);
                }, 
                child: Text('disable'.tr)
              ),
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    isLoading=false;
                  });
                  Navigator.pop(context);
                }, 
                child: Text('enableNavidromeReLogin'.tr)
              ),
            ],
          ),
        );
        if(enableNavidrome){
          c.useNavidromeAPI.value=true;
          prefs.setBool("useNavidrome", true);
          return;
        }else{
          c.useNavidromeAPI.value=false;
          prefs.setBool("useNavidrome", false);
        }
      }
      c.userInfo.value=UserInfo.fromJson({
        'url': userData['url'],
        'username': userData['username'],
        'salt': userData['salt'],
        'token': userData['token'],
        'password': userData['password']
      });
      if(c.useNavidromeAPI.value && c.userInfo.value.password!=null){
        await requests.getNavidromeAuth();
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        color: colorController.color1(),
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.transparent,
              child: Platform.isWindows ? Row(
                children: [
                  Expanded(child: DragToMoveArea(child: Container())),
                  WindowCaptionButton.minimize(
                    onPressed: minWindow,
                    brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
                  ),
                  Obx(()=>
                    c.maxWindow.value ? WindowCaptionButton.unmaximize(
                      onPressed: unmaxWindow,
                      brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
                    ) : WindowCaptionButton.maximize(
                      onPressed: maxWindow,
                      brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
                    ),
                  ),
                  WindowCaptionButton.close(
                    onPressed: ()=>operations.closeWindow(),
                    brightness: colorController.darkMode.value ? Brightness.dark : Brightness.light,
                  )
                ],
              ) : DragToMoveArea(child: Container())
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading ? Center(
                  key: const Key('1'),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: LoadingAnimationWidget.beat(
                      color: colorController.color6(), 
                      size: 30
                    ),
                  ),
                ) : isLogin ? const MainView(key: Key('2'),) : const LoginView(key: Key('3'),),
              ),
            ),
            Platform.isMacOS ? 
            PlatformMenuBar(
              menus: [
                PlatformMenu(
                  label: "netPlayer", 
                  menus: [
                    PlatformMenuItemGroup(
                      members: [
                        PlatformMenuItem(
                          label: "About netPlayer".tr,
                          onSelected: (){
                            operations.showAbout(context);
                          }
                        )
                      ]
                    ),
                    PlatformMenuItemGroup(
                      members: [
                        PlatformMenuItem(
                          label: "Settings...".tr,
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.comma,
                            meta: true,
                          ),
                          onSelected: isLogin ? (){
                            if(c.showLyric.value){
                              operations.toggleLyric(context);
                            }
                            c.page.value=Pages.settings;
                          } : null
                        ),
                      ]
                    ),
                    const PlatformMenuItemGroup(
                      members: [
                        PlatformProvidedMenuItem(
                          enabled: true,
                          type: PlatformProvidedMenuItemType.hide,
                        ),
                        PlatformProvidedMenuItem(
                          enabled: true,
                          type: PlatformProvidedMenuItemType.quit,
                        ),
                      ]
                    )
                  ]
                ),
                PlatformMenu(
                  label: "Edit".tr,
                  menus: [
                    PlatformMenuItem(
                      label: "Copy".tr,
                      onSelected: (){
                        final focusedContext = FocusManager.instance.primaryFocus?.context;
                        if (focusedContext != null) {
                          Actions.invoke(focusedContext, CopySelectionTextIntent.copy);
                        }
                      }
                    ),
                    PlatformMenuItem(
                      label: "Paste".tr,
                      onSelected: (){
                        final focusedContext = FocusManager.instance.primaryFocus?.context;
                        if (focusedContext != null) {
                          Actions.invoke(focusedContext, const PasteTextIntent(SelectionChangedCause.keyboard));
                        }
                      },
                    ),
                    PlatformMenuItem(
                      label: "Select All".tr,
                      onSelected: (){
                        final focusedContext = FocusManager.instance.primaryFocus?.context;
                        if (focusedContext != null) {
                          Actions.invoke(focusedContext, const SelectAllTextIntent(SelectionChangedCause.keyboard));
                        }
                      }
                    )
                  ]
                ),
                PlatformMenu(
                  label: "Control".tr, 
                  menus: [
                    PlatformMenuItemGroup(
                      members: [
                        PlatformMenuItem(
                          label: "Play/Pause".tr,
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.space,
                          ),
                          onSelected: (){
                            operations.toggleSong();
                          },
                        ),
                        PlatformMenuItem(
                          label: "Skip Forward".tr,
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.arrowLeft,
                            meta: true,
                          ),
                          onSelected: (){
                            operations.skipPre();
                          },
                        ),
                        PlatformMenuItem(
                          label: "Skip Next".tr,
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.arrowRight,
                            meta: true,
                          ),
                          onSelected: (){
                            operations.skipNext();
                          },
                        ),
                      ]
                    ),
                    PlatformMenuItemGroup(
                      members: [
                        PlatformMenuItem(
                          label: "Show/Hide Lyric".tr,
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyL,
                            meta: true
                          ),
                          onSelected: (){
                            operations.toggleLyric(context);
                          },
                        )
                      ]
                    )
                  ]
                ),
                PlatformMenu(
                  label: "Window".tr, 
                  menus: [
                    const PlatformMenuItemGroup(
                      members: [
                        PlatformProvidedMenuItem(
                          enabled: true,
                          type: PlatformProvidedMenuItemType.minimizeWindow,
                        ),
                        PlatformProvidedMenuItem(
                          enabled: true,
                          type: PlatformProvidedMenuItemType.toggleFullScreen,
                        )
                      ]
                    )
                  ]
                )
              ]
            ) : Container()
          ],
        ),
      ),
    );
  }
}