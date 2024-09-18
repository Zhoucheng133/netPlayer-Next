import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
    c.ws.stop();
    super.dispose();
  }

  @override
  void onWindowMaximize(){
    c.maxWindow.value=true;
  }

  @override
  void onWindowUnmaximize(){
    c.maxWindow.value=false;
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


  final Controller c = Get.put(Controller());
  var isLogin=false;
  var isLoading=true;

  void setLogin(){
    if(c.userInfo['username']!=null){
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
        Get.updateLocale(locale);
        c.lang.value="${locale.languageCode}_${locale.countryCode}";
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


    final userInfo=prefs.getString('userInfo');
    if(userInfo!=null){
      final userData=jsonDecode(userInfo);
      final requests=HttpRequests();
      final rlt=await requests.loginRequest(userData['url'], userData['username'], userData['salt'], userData['token']);
      if(rlt.isEmpty){
        WidgetsBinding.instance.addPostFrameCallback((_){
          showDialog(
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
        });
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
      c.userInfo.value={
        'url': userData['url'],
        'username': userData['username'],
        'salt': userData['salt'],
        'token': userData['token'],
      };
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.transparent,
          child: Platform.isWindows ? Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              WindowCaptionButton.minimize(onPressed: minWindow,),
              Obx(()=>
                c.maxWindow.value ? WindowCaptionButton.unmaximize(onPressed: unmaxWindow) : WindowCaptionButton.maximize(onPressed: maxWindow,),
              ),
              WindowCaptionButton.close(onPressed: (){
                operations.closeWindow();
              },)
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
                  color: c.color6, 
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
                      label: "关于 netPlayer",
                      onSelected: (){
                        operations.showAbout(context);
                      }
                    )
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "设置...",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.comma,
                        meta: true,
                      ),
                      onSelected: isLogin ? (){
                        if(c.showLyric.value){
                          operations.toggleLyric(context);
                        }
                        c.pageIndex.value=6;
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
              label: "编辑",
              menus: [
                PlatformMenuItem(
                  label: "拷贝",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyC,
                    meta: true
                  ),
                  onSelected: (){}
                ),
                PlatformMenuItem(
                  label: "粘贴",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyV,
                    meta: true
                  ),
                  onSelected: (){}
                ),
                PlatformMenuItem(
                  label: "全选",
                  shortcut: const SingleActivator(
                    LogicalKeyboardKey.keyA,
                    meta: true
                  ),
                  onSelected: (){}
                )
              ]
            ),
            PlatformMenu(
              label: "操作", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "暂停/播放",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.space,
                      ),
                      onSelected: (){},
                    ),
                    PlatformMenuItem(
                      label: "上一首",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.arrowLeft,
                        meta: true,
                      ),
                      onSelected: (){},
                    ),
                    PlatformMenuItem(
                      label: "下一首",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.arrowRight,
                        meta: true,
                      ),
                      onSelected: (){},
                    ),
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "显示/隐藏歌词",
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
            const PlatformMenu(
              label: "窗口", 
              menus: [
                PlatformMenuItemGroup(
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
    );
  }
}