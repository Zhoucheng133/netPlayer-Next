// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/functions/hotkeys.dart';
import 'package:net_player_next/View/functions/requests.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Operations{
  final requests=HttpRequests();
  final Controller c = Get.put(Controller());

  // 获取所有的歌单
  Future<void> getAllPlayLists(BuildContext context) async {
    final rlt=await requests.playListsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取歌单失败', context);
      return;
    }else{
      try {
        c.playLists.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {}
    }
  }

  // 添加歌单
  Future<void> addPlayList(BuildContext context, String name) async {
    if(name.isEmpty){
      showMessage(false, '歌单名称不能为空', context);
    }else{
      final rlt=await requests.createPlayListRequest(name);
      Navigator.pop(context);
      if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
        showMessage(false, '创建歌单失败', context);
      }else{
        showMessage(true, '创建歌单成功', context);
      }
      getAllPlayLists(context);
    }
  }

  // 重命名歌单
  Future<void> renamePlayList(BuildContext context, String id, String name) async {
    final rlt=await requests.renameList(id, name);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '重命名歌单失败', context);
      return;
    }else{
      showMessage(true, '重命名歌单成功', context);
      getAllPlayLists(context);
    }
  }

  // 删除歌单
  Future<void> delPlayList(BuildContext context, String id) async {
    final rlt=await requests.delPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '删除歌单失败', context);
      return;
    }else{
      showMessage(true, '删除歌单成功', context);
      getAllPlayLists(context);
    }
  }

  // 获取所有歌曲
  Future<void> getAllSongs(BuildContext context) async {
    final rlt=await requests.getAllSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取所有歌曲失败', context);
      return;
    }else{
      try {
        var tmpList=rlt['subsonic-response']['randomSongs']['song'];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        c.allSongs.value=tmpList;
      } catch (_) {
        showMessage(false, '解析所有歌曲失败', context);
        return;
      }
    }
  }

  // 获取喜欢的歌曲
  Future<void> getLovedSongs(BuildContext context) async {
    final rlt=await requests.getLovedSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取喜欢的歌曲失败', context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['starred']['song']==null){
          return;
        }else{
          c.lovedSongs.value=rlt['subsonic-response']['starred']['song'];
        }
      } catch (_) {
        showMessage(false, '解析喜欢的歌曲失败', context);
        return;
      }
    }
  }

  // 获取指定id歌单
  Future<List> getPlayList(BuildContext context, String id) async {
    final rlt=await requests.getPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取歌单内容失败', context);
      return [];
    }else{
      try {
        return rlt["subsonic-response"]["playlist"]['entry'];
      } catch (_) {}
    }
    return [];
  }

  // 喜欢某个歌曲
  Future<void> loveSong(BuildContext context, String id) async {
    final rlt=await requests.loveSongRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '添加失败', context);
      return;
    }else{
      showMessage(true, '添加成功', context);
    }
    getLovedSongs(context);
    // TODO 重新加载播放列表(若需要)
  }

  // 取消喜欢
  Future<void> deloveSong(BuildContext context, String id) async {
    final rlt=await requests.deLoveSongRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '取消失败', context);
      return;
    }else{
      showMessage(true, '取消成功', context);
    }
    getLovedSongs(context);
    // TODO 重新加载播放列表(若需要)
  }

  // 播放歌曲
  void playSong(BuildContext context, String id, String title, String artist, String playFrom, int duration, String listId, int index, List list){
    List playList=[];
    if(playFrom=='all'){
      playList=c.allSongs;
    }else if(playFrom=='loved'){
      playList=c.lovedSongs;
    }else{
      playList=list;
    }
    Map<String, Object> data={
      'id': id,
      'title': title,
      'artist': artist,
      'playFrom': playFrom,
      'duration': duration,
      'fromId': listId,
      'index': index,
      'list': playList,
    };
    // c.nowPlay.value=data;
    c.updateNowPlay(data);
    c.handler.play();
    c.isPlay.value=true;
  }

  // 播放/暂停
  void toggleSong(){
    if(c.isPlay.value){
      pause();
    }else{
      play();
    }
  }

  // 暂停
  void pause(){
    if(c.nowPlay['id']==''){
      return;
    }
    // print("pause");
    c.handler.pause();
    c.isPlay.value=false;
  }

  // 播放
  void play(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.play();
    c.isPlay.value=true;
  }

  // 下一首
  void skipNext(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.skipToNext();
    c.isPlay.value=true;
  }

  // 上一首
  void skipPre(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.skipToPrevious();
    c.isPlay.value=true;
  }

  // 定位
  void seek(Duration d){
    c.handler.seek(d);
    play();
  }

  // 定位时间轴
  void seekSong(double val){
    if(c.nowPlay['id']==''){
      return;
    }
    pause();
    int progress=(c.nowPlay['duration']*1000*val).toInt();
    c.playProgress.value=progress;
    EasyDebounce.debounce(
      'slider',
      const Duration(milliseconds: 50),
      () {
        seek(Duration(milliseconds: c.playProgress.value));
      }
    );
  }

  // 自动登录切换
  Future<void> autoLogin(bool val) async {
    c.autoLogin.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', val);
  }

  // 保存播放信息切换
  Future<void> savePlay(bool val) async {
    c.savePlay.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('savePlay', val);
  }

  // 关闭窗口后台播放切换
  Future<void> closeOnRun(bool val) async {
    c.closeOnRun.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('closeOnRun', val);
  }
  
  // 启用快捷键切换
  Future<void> useShortcut(bool val) async {
    c.useShortcut.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useShortcut', val);
  }


  // 注册全局快捷键
  Future<void> initHotkey() async {
    await HotkeyHandler().toggleHandler();
    await HotkeyHandler().skipNextHandler();
    await HotkeyHandler().skipPreHandler();
    if(c.useShortcut.value && Platform.isWindows){
      await HotkeyHandler().globalSkipNext();
      await HotkeyHandler().globalSkipPre();
      await HotkeyHandler().globalToggle();
    }
  }
}