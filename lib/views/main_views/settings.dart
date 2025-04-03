// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/components/view_head.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  
  final Controller c = Get.find();
  final ColorController colorController=Get.find();
  bool hoverURL=false;
  bool hoverAbout=false;
  bool hoverWs=false;
  bool refreshing=false;
  bool hoverLang=false;
  bool hoverClear=false;
  bool hoverReloadCache=false;
  bool hoverTheme=false;

  final operations=Operations();
  int cacheSize=0;

  @override
  void initState(){
    super.initState();
    if(Platform.isMacOS){
      getCacheSize();
    }
  }

  Future<void> getCacheSize() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      var size = await operations.getDirectorySize(tempDir);
      setState(() {
        cacheSize=size;
      });
    } catch (_) {
      setState(() {
        cacheSize=0;
      });
    }
  }

  Future<void> refreshLibrary(BuildContext context) async {
    await HttpRequests().refreshLibrary();
    showMessage(true, 'refreshSuccess'.tr, context);
    await operations.getAllSongs(context);
    await operations.getAlbums(context);
    await operations.getArtists(context);
    await operations.getLovedSongs(context);
    operations.nowPlayCheck(context);
    setState(() {
      refreshing=false;
    });
  }

  Future<void> clearController() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      try {
        cacheDir.deleteSync(recursive: true);
      } catch (_) {}
    }
    getCacheSize();
  }

  void wsSetting(BuildContext context){
    var portInput=c.wsPort.value;
    var portController=TextEditingController();
    portController.text=portInput.toString();
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('wsSettings'.tr),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('port'.tr),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(()=>
                        TextField(
                          controller: portController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorController.color3(), width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorController.color5(), width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      )
                    ),
                  ],
                )
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child:  Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () async {
              if(portController.text.isEmpty){
                return;
              }
              c.wsPort.value=int.parse(portController.text);
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('wsPort', int.parse(portController.text));
              Navigator.pop(context);
              showDialog(
                context: context, 
                builder: (BuildContext context)=>AlertDialog(
                  title: Text('applyWS'.tr),
                  content: Text('restartNetp'.tr),
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
            }, 
            child: Text('finish'.tr)
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        children: [
          Row(
            children: [
              Column(
                children: [
                  ViewHeader(title: 'settings'.tr, subTitle: '', page: 'settings',),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('savePlayed'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: colorController.color6(),
                                splashRadius: 0,
                                value: c.savePlay.value, 
                                onChanged: (value){
                                  operations.savePlay(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('autoLogin'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: colorController.color6(),
                                splashRadius: 0,
                                value: c.autoLogin.value, 
                                onChanged: (value){
                                  operations.autoLogin(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Platform.isWindows ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('playBackground'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: colorController.color6(),
                                splashRadius: 0,
                                value: c.closeOnRun.value, 
                                onChanged: (value){
                                  operations.closeOnRun(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableShortcuts'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: colorController.color6(),
                                splashRadius: 0,
                                value: c.useShortcut.value, 
                                onChanged: (value){
                                  operations.useShortcut(value);
                                }
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableWs'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(()=>
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    activeTrackColor: colorController.color6(),
                                    splashRadius: 0,
                                    value: c.useWs.value, 
                                    onChanged: (value){
                                      operations.useWs(value, context);
                                    }
                                  ),
                                )
                              )
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                wsSetting(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverWs=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverWs=false;
                                  });
                                },
                                child: Obx(()=>
                                  AnimatedDefaultTextStyle(
                                    style: GoogleFonts.notoSansSc(
                                      color: hoverWs ? colorController.color6() : colorController.color5()
                                    ), 
                                    duration: const Duration(milliseconds: 200),
                                    child: Text('settings'.tr)
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Platform.isWindows && c.useDesktopLyric ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('enableKit'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(()=>
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                activeTrackColor: colorController.color6(),
                                splashRadius: 0,
                                value: c.useLyricKit.value, 
                                onChanged: c.useWs.value ? (value){
                                  operations.useKit(value, context);
                                }: null
                              ),
                            )
                          )
                        ),
                      )
                    ],
                  ) : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('theme'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(()=>
                                  ColorIndicator(
                                    width: 25,
                                    height: 25,
                                    borderRadius: 7,
                                    color: colorController.baseColor.value,
                                  )
                                ),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: ()=>colorController.colorPickerPanel(context),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_){
                                      setState(() {
                                        hoverTheme=true;
                                      });
                                    },
                                    onExit: (_){
                                      setState(() {
                                        hoverTheme=false;
                                      });
                                    },
                                    child: Obx(()=>
                                      AnimatedDefaultTextStyle(
                                        style: GoogleFonts.notoSansSc(
                                          color: hoverTheme ? colorController.color6() : colorController.color5()
                                        ), 
                                        duration: const Duration(milliseconds: 200),
                                        child: Text('change'.tr)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('serviceUrl'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  final url=Uri.parse(c.userInfo['url']!);
                                  await launchUrl(url);
                                } catch (_) {
                                  return;
                                }
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (_){
                                  setState(() {
                                    hoverURL=true;
                                  });
                                },
                                onExit: (_){
                                  setState(() {
                                    hoverURL=false;
                                  });
                                },
                                child: Obx(()=>
                                  AnimatedDefaultTextStyle(
                                    style: GoogleFonts.notoSansSc(
                                      color: hoverURL ? colorController.color6() : Colors.black,
                                    ), 
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      c.userInfo['url']??'',
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                    )
                                  )
                                ),
                              ),
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('lang'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text('selfLang'.tr),
                                const SizedBox(width: 20,),
                                GestureDetector(
                                  onTap: (){
                                    operations.selectLanguage(context);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_){
                                      setState(() {
                                        hoverLang=true;
                                      });
                                    },
                                    onExit: (_){
                                      setState(() {
                                        hoverLang=false;
                                      });
                                    },
                                    child: Obx(()=>
                                      AnimatedDefaultTextStyle(
                                        style: GoogleFonts.notoSansSc(
                                          color: hoverLang ? colorController.color6() : colorController.color5()
                                        ), 
                                        duration: const Duration(milliseconds: 200),
                                        child: Text('change'.tr)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Platform.isMacOS ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('cache'.tr)
                        )
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        width: 220,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(operations.sizeConvert(cacheSize)),
                                const SizedBox(width: 5,),
                                Obx(()=>
                                  TweenAnimationBuilder(
                                    tween: ColorTween(end: hoverReloadCache ? colorController.color6() : colorController.color5()),
                                    duration: const Duration(milliseconds: 200), 
                                    builder: (_, value, __) => GestureDetector(
                                      onTap: ()=>getCacheSize(),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_){
                                          setState(() {
                                            hoverReloadCache=true;
                                          });
                                        },
                                        onExit: (_){
                                          setState(() {
                                            hoverReloadCache=false;
                                          });
                                        },
                                        child: Icon(
                                          Icons.refresh_rounded,
                                          color: value,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () async {
                                    if(await operations.clearCache(context)){
                                      clearController();
                                    }
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_){
                                      setState(() {
                                        hoverClear=true;
                                      });
                                    },
                                    onExit: (_){
                                      setState(() {
                                        hoverClear=false;
                                      });
                                    },
                                    child: Obx(()=>
                                      AnimatedDefaultTextStyle(
                                        style: GoogleFonts.notoSansSc(
                                          color: hoverClear ? colorController.color6() : colorController.color5()
                                        ), 
                                        duration: const Duration(milliseconds: 200),
                                        child: Text('clear'.tr)
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: refreshing ? null : (){
                        setState(() {
                          refreshing=true;
                        });
                        refreshLibrary(context);
                      }, 
                      child: Obx(()=>
                        Text(
                          'refreshLibrary'.tr,
                          style: GoogleFonts.notoSansSc(
                            color: colorController.color6()
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        operations.showAbout(context);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_){
                          setState(() {
                            hoverAbout=true;
                          });
                        },
                        onExit: (_){
                          setState(() {
                            hoverAbout=false;
                          });
                        },
                        child: Obx(()=>
                          AnimatedDefaultTextStyle(
                            style: GoogleFonts.notoSansSc(
                              color: hoverAbout ? colorController.color6() : colorController.black.value,
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              'aboutNetp'.tr,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        ],
      )
    );
  }
}