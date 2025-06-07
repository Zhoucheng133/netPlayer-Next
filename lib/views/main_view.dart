// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:net_player_next/views/components/side_bar.dart';
import 'package:net_player_next/views/components/play_bar.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/views/functions/ws.dart';
import 'package:net_player_next/views/main_views/album.dart';
import 'package:net_player_next/views/main_views/all.dart';
import 'package:net_player_next/views/main_views/artist.dart';
import 'package:net_player_next/views/main_views/loved.dart';
import 'package:net_player_next/views/main_views/play_list.dart';
import 'package:net_player_next/views/main_views/search.dart';
import 'package:net_player_next/views/main_views/settings.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smtc_windows/smtc_windows.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final Controller c = Get.find();
  late Worker listener;
  late Worker lineListener;
  late Worker statusListener;
  Operations operations=Operations();
  String? preId;
  
  // 是否保存->(是)加载播放信息->是否后台播放->是否所有歌曲随机播放->是否启用全局快捷键->是否自定义播放模式
  Future<void> initPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savePlay=prefs.getBool('savePlay');
    if(savePlay!=false){
      final nowPlay=prefs.getString('nowPlay');
      if(nowPlay!=null){
        Map<String, dynamic> decodedMap = jsonDecode(nowPlay);
        Map<String, Object> tmpList=Map<String, Object>.from(decodedMap);
        c.nowPlay.value=tmpList;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await operations.nowPlayCheck(context);
          if(Platform.isWindows){
            c.smtc.updateMetadata(
              MusicMetadata(
                title: c.nowPlay["title"]??'',
                album: c.nowPlay["album"]??'',
                albumArtist: c.nowPlay["artist"]??'',
                artist: c.nowPlay["artist"]??'',
                thumbnail: "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}"
              ),
            );
            c.smtc.setPlaybackStatus(PlaybackStatus.Paused);
          }
        });
      }
    }else{
      c.savePlay.value=false;
    }
    final closeOnRun=prefs.getBool('closeOnRun');
    if(closeOnRun==false){
      c.closeOnRun.value=false;
    }
    final fullRandomPlay=prefs.getBool('fullRandom');
    if(fullRandomPlay==true && savePlay!=false){
      c.fullRandom.value=true;
    }
    final useShortcut=prefs.getBool('useShortcut');
    if(useShortcut==false){
      c.useShortcut.value=false;
    }
    final playMode=prefs.getString('playMode');
    if(playMode!=null && playMode!='list'){
      c.playMode.value=playMode;
    }
    final volume=prefs.getInt('volume');
    if(volume!=null && volume!=100){
      c.volume.value=volume;
      c.handler.volumeSet(c.volume.value);
    }
    final ws=prefs.getBool('useWs');
    if(ws==true){
      c.useWs.value=true;
      final wsPort=prefs.getInt('wsPort');
      if(wsPort!=null){
        c.wsPort.value=wsPort;
      }
      c.ws=WsService(wsPort??9098);
    }
    operations.initHotkey(context);
  }

  void lyricChange(){
    try {
      // var content=c.lyric[c.lyricLine.value-1]['content'];
      var content=c.lyric[c.lyricLine.value-1].lyric;
      if(c.useWs.value){
        c.ws.sendMsg(content);
      }
    } catch (_) {}
  }

  Future<void> updateCover() async {
    c.coverFuture.value=await operations.fetchCover();
  }

  Future<void> nowplayChange(Map val) async {

    if(preId!=null && c.nowPlay['id']==preId){
      // 实际播放内容没有任何变化
      return;
    }

    if(c.nowPlay['id']!=null && c.nowPlay['id'].isNotEmpty){
      preId=c.nowPlay['id'];
    }

    updateCover();

    // 保存现在播放的内容
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nowPlay', jsonEncode(val));
    c.lyricLine.value=0;
    // 如果id不为空，获取歌词
    c.lyricFrom.value=LyricFrom.none;
    c.lyric.value=[
      // {
      //   'time': 0,
      //   'content': 'searchingLyric'.tr,
      // }
      LyricItem('searchingLyric'.tr, "", 0)
    ];
    var content='searchingLyric'.tr;
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    if(val['id']!=''){
      await operations.getLyric();
    }
  }

  void statusChange(){
    try {
      // var content=c.lyric[c.lyricLine.value-1]['content'];
      var content=c.lyric[c.lyricLine.value-1].lyric;
      if(c.useWs.value){
        c.ws.sendMsg(content);
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    listener=ever(c.nowPlay, (val)=>nowplayChange(val));
    lineListener=ever(c.lyricLine, (val)=>lyricChange());
    statusListener=ever(c.isPlay, (val)=>statusChange());
    initSMTC();
  }

  void initSMTC(){
    if(Platform.isWindows){
      c.smtc = SMTCWindows(
        metadata: MusicMetadata(
          title: c.nowPlay["title"]??'',
          album: c.nowPlay["album"]??'',
          albumArtist: c.nowPlay["artist"]??'',
          artist: c.nowPlay["artist"]??'',
          thumbnail: "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}",
        ),
        config: const SMTCConfig(
          fastForwardEnabled: false,
          nextEnabled: true,
          pauseEnabled: true,
          playEnabled: true,
          rewindEnabled: true,
          prevEnabled: true,
          stopEnabled: true,
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // Listen to button events and update playback status accordingly
          c.smtc.buttonPressStream.listen((event) {
            switch (event) {
              case PressedButton.play:
                // Update playback status
                operations.play();
                c.smtc.setPlaybackStatus(PlaybackStatus.Playing);
                break;
              case PressedButton.pause:
                operations.pause();
                c.smtc.setPlaybackStatus(PlaybackStatus.Paused);
                break;
              case PressedButton.next:
                // print('Next');
                operations.skipNext();
                break;
              case PressedButton.previous:
                // print('Previous');
                operations.skipPre();
                break;
              case PressedButton.stop:
                c.smtc.setPlaybackStatus(PlaybackStatus.Stopped);
                c.smtc.disableSmtc();
                break;
              default:
                break;
            }
          });
        } catch (e) {
          // print("Error: $e");
        }
      });
    }
  }

  @override
  void dispose() {
    listener.dispose();
    statusListener.dispose();
    lineListener.dispose();
    c.smtc.dispose();
    super.dispose();
  }

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 150,
                child: SideBar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  child: Obx(()=>
                    Container(
                      decoration: BoxDecoration(
                        color: colorController.darkMode.value ? colorController.color2() : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Obx(()=>
                        IndexedStack(
                          index: c.pageIndex.value,
                          children: const [
                            AllView(),
                            LovedView(),
                            ArtistView(),
                            AlbumView(),
                            PlayListView(),
                            SearchView(),
                            SettingsView()
                          ],
                        )
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        const SizedBox(
          height: 80,
          child: PlayBar(),
        )
      ],
    );
  }
}