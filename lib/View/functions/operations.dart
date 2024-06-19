// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/functions/hotkeys.dart';
import 'package:net_player_next/View/functions/requests.dart';
import 'package:net_player_next/View/mainViews/lyric.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

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

  // 获取所有的专辑
  Future<void> getAlbums(BuildContext context) async {
    final rlt=await requests.getAlbumsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取喜欢的歌曲失败', context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['albumList']['album']==null){
          return;
        }else{
          c.albums.value=rlt['subsonic-response']['albumList']['album'];
        }
      } catch (_) {
        showMessage(false, '解析所有专辑失败', context);
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

  // 获取所有艺人
  Future<void> getArtists(BuildContext context) async {
    final rlt=await requests.getArtistRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取所有艺人失败', context);
      return;
    }else{
      try {
        var list=[];
        var tmp=rlt['subsonic-response']["artists"]["index"].map((item) => item['artist']).toList();
        for(var i=0;i<tmp.length;i++){
          for(var j=0;j<tmp[i].length;j++){
            list.add(tmp[i][j]);
          }
        }
        c.artists.value=list;
      } catch (_) {}
    }
  }

  // 重新刷新播放内容
  void refreshFromLoved(){
    if(c.nowPlay['playFrom']=='loved'){
      int index=c.lovedSongs.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        c.nowPlay['index']=index;
        c.nowPlay['list']=c.lovedSongs;
        c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'album': '',
          'index': 0,
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
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
    await getLovedSongs(context);
    refreshFromLoved();
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
    await getLovedSongs(context);
    refreshFromLoved();
  }

  // 添加某个歌曲到某个歌单
  Future<void> addToList(BuildContext context, String songId, String listId) async {
    final rlt=await requests.addToListRequest(songId, listId);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '添加失败', context);
      return;
    }else{
      showMessage(true, '添加成功', context);
    }
    c.nowPlay['list']=await getPlayList(context, listId);
    c.nowPlay.refresh();
  }

  // 喜欢的歌曲播放检查
  Future<void> checkLovedSongPlay(BuildContext context) async {
    await getLovedSongs(context);
    if(c.nowPlay['playFrom']=='loved'){
      int index=c.lovedSongs.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        // c.nowPlay['index']=index;
        // c.nowPlay['list']=c.lovedSongs;
        // c.nowPlay.refresh();
        Map<String, Object> tmp={
          'id': c.nowPlay['id'],
          'title': c.nowPlay['title'],
          'artist': c.nowPlay['artist'],
          'playFrom': c.nowPlay['playFrom'],
          'duration': c.nowPlay['duration'],
          'fromId': c.nowPlay['fromId'],
          'album': c.nowPlay['album'],
          'index': index,
          'list': c.lovedSongs,
        };
        c.nowPlay.value=tmp;
        // c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'index': 0,
          'album': '',
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
  }

  // 所有歌曲播放检查
  Future<void> checkAllSongPlay(BuildContext context) async {
    await getAllSongs(context);
    if(c.nowPlay['playFrom']=='all'){
      int index=c.allSongs.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        // c.nowPlay['index']=index;
        // c.nowPlay['list']=c.allSongs;
        // c.nowPlay.refresh();
        Map<String, Object> tmp={
          'id': c.nowPlay['id'],
          'title': c.nowPlay['title'],
          'artist': c.nowPlay['artist'],
          'playFrom': c.nowPlay['playFrom'],
          'duration': c.nowPlay['duration'],
          'fromId': c.nowPlay['fromId'],
          'album': c.nowPlay['album'],
          'index': index,
          'list': c.allSongs,
        };
        c.nowPlay.value=tmp;
        // c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'index': 0,
          'list': [],
          'album': '',
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
  }

  // 歌单播放检查
  Future<void> checkPlayListPlay(BuildContext context, String listId) async {
    var tmpList=await getPlayList(context, listId);
    if(c.nowPlay['playFrom']=='playList' && c.nowPlay['fromId']==listId){
      int index=tmpList.indexWhere((item) => item['id']==c.nowPlay['id']);
      if(index!=-1){
        // c.nowPlay['index']=index;
        // c.nowPlay['list']=tmpList;
        Map<String, Object> tmp={
          'id': c.nowPlay['id'],
          'title': c.nowPlay['title'],
          'artist': c.nowPlay['artist'],
          'playFrom': c.nowPlay['playFrom'],
          'duration': c.nowPlay['duration'],
          'fromId': c.nowPlay['fromId'],
          'album': c.nowPlay['album'],
          'index': index,
          'list': tmpList,
        };
        c.nowPlay.value=tmp;
        // c.nowPlay.refresh();
      }else{
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'album': '',
          'index': 0,
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
  }

  // 自动修正nowPlay
  Future<void> nowPlayCheck(BuildContext context) async {
    if(c.nowPlay['id']==''){
      return;
    }else{
      if(c.nowPlay['playFrom']=='all'){
        await checkAllSongPlay(context);
      }else if(c.nowPlay['playFrom']=='loved'){
        await checkLovedSongPlay(context);
      }else if(c.nowPlay['playFrom']=='playList'){
        await checkPlayListPlay(context, c.nowPlay['fromId']);
      }else if(c.nowPlay['playFrom']=='album'){
        c.handler.stop();
        Map<String, Object> tmp={
          'id': '',
          'title': '',
          'artist': '',
          'playFrom': '',
          'duration': 0,
          'fromId': '',
          'index': 0,
          'album': '',
          'list': [],
        };
        c.nowPlay.value=tmp;
        c.isPlay.value=false;
      }
    }
  }

  // 所有歌曲随机播放
  Future<void> fullRandomPlay() async {
    final rlt=await requests.getRandomSongRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      c.handler.stop();
      Map<String, Object> tmp={
        'id': '',
        'title': '',
        'artist': '',
        'playFrom': '',
        'duration': 0,
        'fromId': '',
        'index': 0,
        'album': '',
        'list': [],
      };
      c.nowPlay.value=tmp;
      c.isPlay.value=false;
      return;
    }else{
      var tmp=rlt['subsonic-response']['randomSongs']['song'][0];
      Map<String, Object> rdSong={
        'id': tmp['id'],
        'title': tmp['title'],
        'artist': tmp['artist'],
        'playFrom': 'fullRandom',
        'duration': tmp['duration'],
        'album': tmp['album'],
        'fromId': '',
        'index': 0,
        'list': [],
      };
      c.nowPlay.value=rdSong;
      c.handler.play();
      c.isPlay.value=true;
    }
  }

  // 完全随机播放切换
  Future<void> fullRandomPlaySwitcher(BuildContext context) async {
    if(c.fullRandom.value==false){
      fullRandomPlay();
    }else{
      c.handler.stop();
      Map<String, Object> tmp={
        'id': '',
        'title': '',
        'artist': '',
        'playFrom': '',
        'duration': 0,
        'fromId': '',
        'album': '',
        'index': 0,
        'list': [],
      };
      c.nowPlay.value=tmp;
      c.isPlay.value=false;
    }
    c.fullRandom.value=!c.fullRandom.value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fullRandom', c.fullRandom.value);
  }
  
  // 时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  // 获取歌词
  Future<void> getLyric() async {
    final rlt=await requests.getLyricRequest(c.nowPlay['title'], c.nowPlay['album'], c.nowPlay['artist'], c.nowPlay['duration'].toString());
    var response=rlt['syncedLyrics']??"";
    if(response==''){
      c.lyric.value=[
        {
          'time': 0,
          'content': '没有找到歌词',
        }
      ];
      var content='没有找到歌词';
      c.ws.sendMsg(content);
    }else{
      List lyricCovert=[];
      List<String> lines = LineSplitter.split(response).toList();
      for(String line in lines){
        int pos1=line.indexOf("[");
        int pos2=line.indexOf("]");
        lyricCovert.add({
          'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
          'content': line.substring(pos2 + 1).trim(),
        });
      }
      c.lyric.value=lyricCovert;
      var content='';
      c.ws.sendMsg(content);
    }
  }

  // 将某个歌曲从歌单中删除
  Future<bool> delFromList(BuildContext context, String listId, int songId) async {
    final rlt=await requests.delFromListRequest(listId, songId);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '删除失败', context);
      return false;
    }else{
      showMessage(true, '删除成功', context);
      checkPlayListPlay(context, listId);
      return true;
    }
  }

  // 获取某个专辑信息
  Future<Map> getAlbumData(BuildContext context, String id) async {
    final rlt=await requests.getAlbumDataRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取专辑信息失败', context);
      return {};
    }else{
      try {
        // print(rlt['subsonic-response']['album']);
        return rlt['subsonic-response']['album'];
      } catch (_) {}
      return {};
    }
  }

  // 获取某个艺人信息
  Future<Map> getArtistData(BuildContext context, String id) async {
    final rlt=await requests.getArtistDataRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取艺人信息失败', context);
      return {};
    }else{
      try {
        return rlt['subsonic-response']['artist'];
      } catch (_) {}
      return {};
    }
  }

  // 显示/隐藏歌词
  void toggleLyric(BuildContext context){
    if(c.showLyric.value){
      c.showLyric.value=false;
      Navigator.pop(context);
    }else{
      c.showLyric.value=true;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const lyricView(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        )
      );
    }
  }

  // 修改音量
  Future<void> saveVolume() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('volume', c.volume.value);
  }

  // 播放歌曲
  Future<void> playSong(BuildContext context, String id, String title, String artist, String playFrom, int duration, String listId, int index, List list, String album) async {
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
      'album': album,
      'index': index,
      'list': playList,
    };
    c.nowPlay.value=data;
    c.handler.play();
    c.isPlay.value=true;
    if(c.fullRandom.value){
      c.fullRandom.value=false;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fullRandom', false);
    }
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
  Future<void> initHotkey(BuildContext context) async {
    await HotkeyHandler().toggleHandler();
    await HotkeyHandler().skipNextHandler();
    await HotkeyHandler().skipPreHandler();
    await HotkeyHandler().toggleLyric(context);
    if(c.useShortcut.value && Platform.isWindows){
      await HotkeyHandler().globalSkipNext();
      await HotkeyHandler().globalSkipPre();
      await HotkeyHandler().globalToggle();
    }
  }

  // 关闭窗口
  void closeWindow(){
    if(Platform.isWindows){
      if(c.closeOnRun.value==false){
        windowManager.close();
      }else{
        windowManager.hide();
      }
    }else{
      windowManager.close();
    }
  }

  // 显示关于
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
}