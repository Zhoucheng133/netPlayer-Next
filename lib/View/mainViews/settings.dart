// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/View/components/viewHead.dart';
import 'package:net_player_next/View/functions/operations.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  Future<void> showAbout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: const Text('关于'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
            ),
            const SizedBox(height: 10,),
            const Text(
              'netPlayer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              'Next v${packageInfo.version}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                final url=Uri.parse('https://github.com/Zhoucheng133/netPlayer-Next');
                launchUrl(url);
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    SizedBox(width: 5,),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        '本项目地址',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                final url=Uri.parse('https://lrclib.net/docs');
                launchUrl(url);
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.code_rounded,
                      size: 15,
                    ),
                    SizedBox(width: 5,),
                    Text('歌词API'),
                  ],
                ),
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('好的')
          )
        ],
      ),
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
                    showAbout(context);
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