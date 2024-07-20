// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {
  
  final Controller c = Get.put(Controller());
  bool hoverURL=false;
  bool hoverAbout=false;
  bool hoverWs=false;

  void wsSetting(BuildContext context){
    var portInput=c.wsPort.value;
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: const Text('WebSocket服务设置'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('端口'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 120,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(portInput.toString()),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                portInput-=1;
                              });
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.remove_rounded,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                portInput+=1;
                              });
                            },
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 15,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    )
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
            child:  const Text('取消')
          ),
          ElevatedButton(
            onPressed: () async {
              c.wsPort.value=portInput;
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('wsPort', portInput);
              Navigator.pop(context);
              showDialog(
                context: context, 
                builder: (BuildContext context)=>AlertDialog(
                  title: const Text('应用WebSocket设置'),
                  content: const Text('重启netPlayer来应用设置'),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text('好的')
                    )
                  ],
                )
              );
            }, 
            child: const Text('完成')
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
                  const viewHeader(title: '设置', subTitle: '', page: 'settings',),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('保存播放的歌曲')
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
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.savePlay.value, 
                                onChanged: (value){
                                  Operations().savePlay(value);
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
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('自动登录')
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
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.autoLogin.value, 
                                onChanged: (value){
                                  Operations().autoLogin(value);
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
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('后台播放')
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
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.closeOnRun.value, 
                                onChanged: (value){
                                  Operations().closeOnRun(value);
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
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('启用全局快捷键')
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
                                activeTrackColor: c.color6,
                                splashRadius: 0,
                                value: c.useShortcut.value, 
                                onChanged: (value){
                                  Operations().useShortcut(value);
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
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('启用ws服务')
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
                                    activeTrackColor: c.color6,
                                    splashRadius: 0,
                                    value: c.useWs.value, 
                                    onChanged: (value){
                                      Operations().useWs(value, context);
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
                                child: AnimatedDefaultTextStyle(
                                  style: GoogleFonts.notoSansSc(
                                    color: hoverWs ? c.color6 : c.color5
                                  ), 
                                  duration: const Duration(milliseconds: 200),
                                  child: const Text('设置')
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('服务器地址')
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
                                    style: TextStyle(
                                      color: hoverURL ? c.color6 : Colors.black,
                                      overflow: TextOverflow.fade,
                                    ), 
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      c.userInfo['url']??'',
                                      softWrap: false,
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
                child: GestureDetector(
                  onTap: (){
                    Operations().showAbout(context);
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
                    child: AnimatedDefaultTextStyle(
                      style: GoogleFonts.notoSansSc(
                        color: hoverAbout ? c.color6 : Colors.black,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: const Text(
                        '关于 netPlayer',
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      )
    );
  }
}