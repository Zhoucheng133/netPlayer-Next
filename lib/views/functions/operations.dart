// ignore_for_file: use_build_context_synchronously

import 'dart:async';
// import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/functions/hotkeys.dart';
import 'package:net_player_next/views/functions/lyric_get.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:net_player_next/views/main_views/lyric.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;


class Operations{
  final requests=HttpRequests();
  final Controller c = Get.put(Controller());
  final lyricGet = LyricGet();

  // 获取所有的歌单
  Future<void> getAllPlayLists(BuildContext context) async {
    final rlt=await requests.playListsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getPlaylistsFail'.tr, context);
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
      showMessage(false, 'playlistNameEmpty'.tr, context);
    }else{
      final rlt=await requests.createPlayListRequest(name);
      Navigator.pop(context);
      if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
        showMessage(false, 'createPlaylistFail'.tr, context);
      }else{
        showMessage(true, 'createPlaylistSuccess'.tr, context);
      }
      getAllPlayLists(context);
    }
  }

  // 重命名歌单
  Future<void> renamePlayList(BuildContext context, String id, String name) async {
    final rlt=await requests.renameList(id, name);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'renameFail'.tr, context);
      return;
    }else{
      showMessage(true, 'renameSuccess'.tr, context);
      getAllPlayLists(context);
    }
  }

  // 删除歌单
  Future<void> delPlayList(BuildContext context, String id) async {
    final rlt=await requests.delPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'delFail'.tr, context);
      return;
    }else{
      showMessage(true, 'delSuccess'.tr, context);
      getAllPlayLists(context);
    }
  }

  // 获取所有歌曲
  Future<void> getAllSongs(BuildContext context) async {
    final rlt=await requests.getAllSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getAllSongFail'.tr, context);
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
        showMessage(false, 'anayliseAllSongFail'.tr, context);
        return;
      }
    }
  }

  // 获取喜欢的歌曲
  Future<void> getLovedSongs(BuildContext context) async {
    final rlt=await requests.getLovedSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getLovedSongFail'.tr, context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['starred']['song']==null){
          c.lovedSongs.value=[];
          return;
        }else{
          c.lovedSongs.value=rlt['subsonic-response']['starred']['song'];
        }
      } catch (_) {
        showMessage(false, 'analiseLovedSongFail'.tr, context);
        return;
      }
    }
  }

  // 获取所有的专辑
  Future<void> getAlbums(BuildContext context) async {
    final rlt=await requests.getAlbumsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getAllAlbumFail'.tr, context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['albumList']['album']==null){
          return;
        }else{
          c.albums.value=rlt['subsonic-response']['albumList']['album'];
        }
      } catch (_) {
        showMessage(false, 'analiseAllAlbumFail'.tr, context);
        return;
      }
    }
  }

  // 获取指定id歌单
  Future<List> getPlayList(BuildContext context, String id) async {
    final rlt=await requests.getPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getPlaylistFail'.tr, context);
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
      showMessage(false, 'getAllArtistFail'.tr, context);
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
      showMessage(false, 'addFail'.tr, context);
      return;
    }else{
      showMessage(true, 'addSuccess'.tr, context);
    }
    await getLovedSongs(context);
    refreshFromLoved();
  }

  // 取消喜欢
  Future<void> deloveSong(BuildContext context, String id) async {
    final rlt=await requests.deLoveSongRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'deloveFail'.tr, context);
      return;
    }else{
      showMessage(true, 'deloveSuccess'.tr, context);
    }
    await getLovedSongs(context);
    refreshFromLoved();
  }

  // 添加某个歌曲到某个歌单
  Future<void> addToList(BuildContext context, String songId, String listId) async {
    final rlt=await requests.addToListRequest(songId, listId);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'addFail'.tr, context);
      return;
    }else{
      showMessage(true, 'addSuccess'.tr, context);
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
      }else if(c.nowPlay['playFrom']=='album' || c.nowPlay['playFrom']=='search'){
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

  // ws服务
  Future<void> useWs(bool val, BuildContext context) async {
    if(val==true){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('enableWs'.tr),
          content: SizedBox(
            width: 300,
            child: Text('enableWsContent'.tr)
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(
                'cancel'.tr
              )
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('useWs', true);
                windowManager.close();
              }, 
              child: Text('continueCloseApp'.tr)
            )
          ],
        )
      );
    }else{
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('closeWs'.tr),
          content: SizedBox(
            width: 300,
            child: Text('closeWsContent'.tr)
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text(
                'cancel'.tr
              )
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('useWs', false);
                windowManager.close();
              }, 
              child: Text('continueCloseApp'.tr)
            )
          ],
        )
      );
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
  

  // 获取歌词
  Future<void> getLyric() async {
    await lyricGet.getLyric();
  }

  // 将某个歌曲从歌单中删除
  Future<bool> delFromList(BuildContext context, String listId, int songId) async {
    final rlt=await requests.delFromListRequest(listId, songId);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'delFail'.tr, context);
      return false;
    }else{
      showMessage(true, 'delSuccess'.tr, context);
      checkPlayListPlay(context, listId);
      return true;
    }
  }

  // 获取某个专辑信息
  Future<Map> getAlbumData(BuildContext context, String id) async {
    final rlt=await requests.getAlbumDataRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'getAlbumInfoFail'.tr, context);
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
      showMessage(false, 'getArtistInfoFail'.tr, context);
      return {};
    }else{
      try {
        return rlt['subsonic-response']['artist'];
      } catch (_) {}
      return {};
    }
  }

  // 全局搜索
  Future<Map> getSearch(BuildContext context, String val) async {
    final rlt=await requests.searchRequest(val);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, 'searchFail'.tr, context);
      return {};
    }else{
      try {
        return {
          "songs": rlt["subsonic-response"]["searchResult2"]["song"]??[],
          "albums": rlt["subsonic-response"]["searchResult2"]["album"]??[],
          "artists": rlt["subsonic-response"]["searchResult2"]["artist"]??[]
        };
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
          pageBuilder: (context, animation, secondaryAnimation) => const LyricView(),
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
    if(c.onInput.value){
      return;
    }
    if(c.isPlay.value){
      pause();
    }else{
      play();
    }
  }

  // 停止播放
  void stop(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.stop();
    c.isPlay.value=false;
  }

  // 暂停
  void pause(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.pause();
    // c.isPlay.value=false;
  }

  // 播放
  void play(){
    if(c.nowPlay['id']==''){
      return;
    }
    c.handler.play();
    // c.isPlay.value=true;
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
  Future<void> seek(Duration d) async {
    await c.handler.seek(d);
    // play();
    // Future.microtask((){
    //   play();
    // });
  }

  void seekChange(double val){
    pause();
    if(c.nowPlay['id']==''){
      return;
    }
    int progress=(c.nowPlay['duration']*1000*val).toInt();
    c.playProgress.value=progress;
  }

  // 定位时间轴
  Future<void> seekSong(double val) async {
    if(c.nowPlay['id']==''){
      return;
    }
    pause();
    int progress=(c.nowPlay['duration']*1000*val).toInt();
    c.playProgress.value=progress;
    await seek(Duration(milliseconds: c.playProgress.value));
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

  // final HotkeyHandler hotkeyHandler=HotkeyHandler();

  // 注册全局快捷键
  Future<void> initHotkey(BuildContext context) async {
    if(Platform.isWindows){
      await HotkeyHandler().toggleHandler();
      await HotkeyHandler().skipNextHandler();
      await HotkeyHandler().skipPreHandler();
      await HotkeyHandler().toggleLyric(context);
      if(c.useShortcut.value){
        await HotkeyHandler().globalSkipNext();
        await HotkeyHandler().globalSkipPre();
        await HotkeyHandler().globalToggle();
      }
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
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('about'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
            ),
            const SizedBox(height: 10,),
            Text(
              'netPlayer',
              style: GoogleFonts.notoSansSc(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              'Next v${c.version}',
              style: GoogleFonts.notoSansSc(
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
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'projectURL'.tr,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: ()=>showLicensePage(context: context),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'license'.tr,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
  }

  // 修改语言
  void selectLanguage(BuildContext context){
    String langSelected=c.lang.value;
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('selectLang'.tr),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)=> DropdownButton2(
            value: langSelected,
            items: const [
              DropdownMenuItem(
                value: 'en_US',
                child: Text('English')
              ),
              DropdownMenuItem(
                value: 'zh_CN',
                child: Text('简体中文')
              ),
              DropdownMenuItem(
                value: 'zh_TW',
                child: Text('繁體中文')
              )
            ], 
            onChanged: (val){
              if(val!=null){
                var parts = val.split('_');
                var locale=Locale(parts[0], parts[1]);
                Get.updateLocale(locale);
                setState((){
                  langSelected=val;
                });
              }
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('lang', langSelected);
              c.lang.value=langSelected;
              Navigator.pop(context);
              showDialog(
                context: context, 
                builder: (context)=>AlertDialog(
                  title: Text('restartTitle'.tr),
                  content: Text('restartToApply'.tr),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text("ok".tr)
                    )
                  ],
                )
              );
            }, 
            child: Text('finish'.tr)
          )
        ],
      ),
    );
  }

  Future<Map> getSongInfo(String id) async {
    final rlt=await requests.getSong(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      return {};
    }else{
      try {
        return rlt['subsonic-response']['song'];
      } catch (_) {}
    }
    return {};
  }

  Future<void> toArtist(BuildContext context) async {
    if(c.nowPlay['id']==""){
      return;
    }
    toggleLyric(context);
    c.pageIndex.value=2;
    final data=await getSongInfo(c.nowPlay['id']);
    if(data.isEmpty){
      return;
    }
    String artistId="";
    try {
      artistId=data['artistId'];
    } catch (_) {
      return;
    }
    c.pageId.value=artistId;
  }

  Future<void> toAlbum(BuildContext context) async {
    if(c.nowPlay['id']==""){
      return;
    }
    toggleLyric(context);
    c.pageIndex.value=3;
    final data=await getSongInfo(c.nowPlay['id']);
    if(data.isEmpty){
      return;
    }
    String albumId="";
    try {
      albumId=data['albumId'];
    } catch (_) {
      return;
    }
    c.pageId.value=albumId;
  }

  // 启用歌词组件
  void useKit(bool val, BuildContext context) {
    // c.useLyricKit.value=val;
    if(val==true){
      try {
        var appPath=Platform.resolvedExecutable;
        appPath=p.dirname(appPath);
        String command=p.join(appPath, 'lyric', 'netplayer_miniplay.exe');
        File file = File(command);
        if (!file.existsSync()) {
          showDialog(
            context: context, 
            builder: (context)=>AlertDialog(
              title: Text('kitFailed'.tr),
              content: Text('kitFailedContent'.tr),
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
          return;
        }

        Process.run(command, [c.wsPort.value.toString(), c.lang.value]);
      } catch (_) {
        return;
      }
      c.useLyricKit.value=true;
    }else{
      c.ws.closeKit();
      c.useLyricKit.value=false;
    }
  }

  Future<Uint8List?> fetchCover() async {
    // print("fetch!");
    if(c.nowPlay["id"]=="" || c.userInfo["url"]==null){
      return null;
    }
    try {
      // 获取文件流
      var response = await http.get(Uri.parse("${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.nowPlay["id"]}")).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return decodeImage(response.bodyBytes)==null ? null:response.bodyBytes;
      } else {
        return null;
      }
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }
}