import 'dart:async';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/album_controller.dart';
import 'package:net_player_next/variables/playlist_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/functions/hotkeys.dart';
import 'package:net_player_next/views/functions/lyric_get.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:net_player_next/views/main_views/lyric.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';


class Operations{
  final requests=HttpRequests();
  final Controller c = Get.find();
  final lyricGet = LyricGet();
  final PlaylistController playlistController=Get.find();
  final SongController songController=Get.find();

  // 获取所有的歌单
  Future<void> getAllPlayLists(BuildContext context, {bool showOkFlash=false}) async {
    final rlt=await requests.playListsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getPlaylistsFail'.tr, context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['playlists'].isEmpty){
          playlistController.playLists.value=[];
        }else{
          final List list=rlt['subsonic-response']['playlists']['playlist'];
          playlistController.playLists.value=list.map((item)=>PlayListItemClass.fromJson(item)).toList();
        }
        if(showOkFlash){
          if(context.mounted) showMessage(true, 'updateOk'.tr, context);
        }
      } catch (_) {
        if(context.mounted) showMessage(false, 'getPlaylistsFail'.tr, context);
      }
    }
  }

  // 添加歌单
  Future<void> addPlayList(BuildContext context, String name) async {
    if(name.isEmpty){
      showMessage(false, 'playlistNameEmpty'.tr, context);
    }else{
      final rlt=await requests.createPlayListRequest(name);
      if(context.mounted) Navigator.pop(context);
      if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
        if(context.mounted) showMessage(false, 'createPlaylistFail'.tr, context);
      }else{
        if(context.mounted) showMessage(true, 'createPlaylistSuccess'.tr, context);
      }
      if(context.mounted) getAllPlayLists(context);
    }
  }

  // 重命名歌单
  Future<void> renamePlayList(BuildContext context, String id, String name) async {
    final rlt=await requests.renameList(id, name);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'renameFail'.tr, context);
      return;
    }else{
      if(context.mounted){
        showMessage(true, 'renameSuccess'.tr, context);
        getAllPlayLists(context);
      }
    }
  }

  // 删除歌单
  Future<void> delPlayList(BuildContext context, String id) async {
    final rlt=await requests.delPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'delFail'.tr, context);
      return;
    }else{
      if(context.mounted){
        showMessage(true, 'delSuccess'.tr, context);
        getAllPlayLists(context);
      }
    }
  }

  // 获取所有歌曲
  Future<void> getAllSongs(BuildContext context) async {
    if(c.useNavidromeAPI.value){
      if(c.uniqueId.value.isEmpty || c.authorization.value.isEmpty){
        await requests.getNavidromeAuth();
      }
      if(c.authorization.isNotEmpty && c.uniqueId.value.isNotEmpty){
        List tmpList=await requests.getAllSongByNavidrome();
        if(tmpList.isNotEmpty){
          tmpList.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(a['createdAt']??a['created']);
            DateTime dateTimeB = DateTime.parse(b['createdAt']??b['created']);
            return dateTimeB.compareTo(dateTimeA);
          });
          songController.allSongs.value=tmpList.map((item)=>SongItemClass.fromJson(item)).toList();
          return;
        }
      }
    }
    final rlt=await requests.getAllSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getAllSongFail'.tr, context);
      return;
    }else{
      try {
        List tmpList=rlt['subsonic-response']['randomSongs']['song'];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        songController.allSongs.value=tmpList.map((item)=>SongItemClass.fromJson(item)).toList();
      } catch (_) {
        if(context.mounted) showMessage(false, 'anayliseAllSongFail'.tr, context);
        return;
      }
    }
  }

  // 获取喜欢的歌曲
  Future<void> getLovedSongs(BuildContext context) async {
    final rlt=await requests.getLovedSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getLovedSongFail'.tr, context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['starred']['song']==null){
          songController.lovedSongs.value=[];
          return;
        }else{
          List songList=rlt['subsonic-response']['starred']['song'];
          songController.lovedSongs.value=songList.map((item)=>SongItemClass.fromJson(item)).toList();
        }
      } catch (_) {
        if(context.mounted) showMessage(false, 'analiseLovedSongFail'.tr, context);
        return;
      }
    }
  }

  // 获取所有的专辑
  Future<void> getAlbums(BuildContext context) async {
    if(c.useNavidromeAPI.value){
      if(c.uniqueId.value.isEmpty || c.authorization.value.isEmpty){
        await requests.getNavidromeAuth();
      }
      if(c.authorization.isNotEmpty && c.uniqueId.value.isNotEmpty){
        List tmpList=await requests.getAlbumsByNavidrome();
        if(tmpList.isNotEmpty){
          c.albums.value=tmpList.map((item)=>AlbumItemClass.fromJson(item)).toList();
          return;
        }
      }
    }
    final rlt=await requests.getAlbumsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getAllAlbumFail'.tr, context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['albumList']['album']==null){
          return;
        }else{
          List list=rlt['subsonic-response']['albumList']['album'];
          c.albums.value=list.map((item)=>AlbumItemClass.fromJson(item)).toList();
        }
      } catch (_) {
        if(context.mounted) showMessage(false, 'analiseAllAlbumFail'.tr, context);
        return;
      }
    }
  }

  // 获取歌单信息
  Future<Map> getPlayListInfo(BuildContext context, String id) async {
    final rlt=await requests.getPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getPlaylistFail'.tr, context);
      return {};
    }else{
      try {
        return rlt["subsonic-response"]["playlist"];
      } catch (_) {}
    }
    return {};
  }

  // 获取指定id歌单
  Future<List> getPlayList(BuildContext context, String id) async {
    final rlt=await requests.getPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getPlaylistFail'.tr, context);
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
      if(context.mounted) showMessage(false, 'getAllArtistFail'.tr, context);
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
    if(songController.nowPlay.value.playFrom==Pages.loved){
      int index=songController.lovedSongs.indexWhere((item) => item.id==songController.nowPlay.value.id);
      if(index!=-1){
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=songController.lovedSongs;
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
  }

  // 喜欢某个歌曲
  Future<void> loveSong(BuildContext context, String id) async {
    final rlt=await requests.loveSongRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'addFail'.tr, context);
      return;
    }else{
      if(context.mounted) showMessage(true, 'addSuccess'.tr, context);
    }
    if(context.mounted) await getLovedSongs(context);
    refreshFromLoved();
  }

  // 取消喜欢
  Future<void> deloveSong(BuildContext context, String id) async {
    final rlt=await requests.deLoveSongRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'deloveFail'.tr, context);
      return;
    }else{
      if(context.mounted) showMessage(true, 'deloveSuccess'.tr, context);
    }
    if(context.mounted) await getLovedSongs(context);
    refreshFromLoved();
  }

  // 添加某个歌曲到某个歌单
  Future<void> addToList(BuildContext context, String songId, String listId) async {
    final rlt=await requests.addToListRequest(songId, listId);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'addFail'.tr, context);
      return;
    }else{
      if(context.mounted) showMessage(true, 'addSuccess'.tr, context);
    }
    if(context.mounted){
      getAllPlayLists(context);
      songController.nowPlay.value.list=(await getPlayList(context, listId)).map((item)=>SongItemClass.fromJson(item)).toList();
    }
    songController.nowPlay.refresh();
  }

  // 喜欢的歌曲播放检查
  Future<void> checkLovedSongPlay(BuildContext context) async {
    await getLovedSongs(context);
    if(songController.nowPlay.value.playFrom==Pages.loved){
      int index=songController.lovedSongs.indexWhere((item) => item.id==songController.nowPlay.value.id);
      if(index!=-1){
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=songController.lovedSongs;
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
  }

  // 所有歌曲播放检查
  Future<void> checkAllSongPlay(BuildContext context) async {
    await getAllSongs(context);
    if(songController.nowPlay.value.playFrom==Pages.all){
      int index=songController.allSongs.indexWhere((item) => item.id==songController.nowPlay.value.id);
      if(index!=-1){
        // songController.nowPlay.value.index=index;
        // songController.nowPlay.value.list=c.allSongs;
        // c.nowPlay.refresh();
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=songController.allSongs;
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
  }

  // 歌单播放检查
  Future<void> checkPlayListPlay(BuildContext context, String listId) async {
    var tmpList=await getPlayList(context, listId);
    if(songController.nowPlay.value.playFrom==Pages.playList && songController.nowPlay.value.fromId==listId){
      int index=tmpList.indexWhere((item) => item['id']==songController.nowPlay.value.id);
      if(index!=-1){
        // songController.nowPlay.value.index=index;
        // songController.nowPlay.value.list=tmpList;
        songController.nowPlay.value.index=index;
        songController.nowPlay.value.list=tmpList.map((item)=>SongItemClass.fromJson(item)).toList();
        // c.nowPlay.refresh();
        songController.nowPlay.refresh();
      }else{
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
        c.isPlay.value=false;
      }
    }
  }

  // 自动修正nowPlay
  Future<void> nowPlayCheck(BuildContext context) async {
    if(songController.nowPlay.value.id==''){
      return;
    }else{
      if(songController.nowPlay.value.playFrom==Pages.all){
        await checkAllSongPlay(context);
      }else if(songController.nowPlay.value.playFrom==Pages.loved){
        await checkLovedSongPlay(context);
      }else if(songController.nowPlay.value.playFrom==Pages.playList){
        await checkPlayListPlay(context, songController.nowPlay.value.fromId);
      }else if(songController.nowPlay.value.playFrom==Pages.album || songController.nowPlay.value.playFrom==Pages.search){
        c.handler.stop();
        songController.nowPlay.value=NowPlay(
          id: '', 
          title: '', 
          artist: '', 
          duration: 0, 
          fromId: '', 
          album: '', 
          albumId: '', 
          artistId: '', 
          created: '', 
          list: [], 
          playFrom: Pages.none, 
          index: 0
        );
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
      songController.nowPlay.value=NowPlay(
        id: '', 
        title: '', 
        artist: '', 
        duration: 0, 
        fromId: '', 
        album: '', 
        albumId: '', 
        artistId: '', 
        created: '', 
        list: [], 
        playFrom: Pages.none, 
        index: 0
      );
      c.isPlay.value=false;
      return;
    }else{
      var tmp=rlt['subsonic-response']['randomSongs']['song'][0];
      songController.nowPlay.value=NowPlay(
        id: tmp['id'], 
        title: tmp['title'], 
        artist: tmp['artist'], 
        duration: tmp['duration'], 
        fromId: "",
        album: tmp['album'], 
        albumId: tmp['albumId'], 
        artistId: tmp['artistId'], 
        created: tmp['created'], 
        list: [], 
        playFrom: Pages.random, 
        index: 0
      );
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
      songController.nowPlay.value=NowPlay(
        id: '', 
        title: '', 
        artist: '', 
        duration: 0, 
        fromId: '', 
        album: '', 
        albumId: '', 
        artistId: '', 
        created: '', 
        list: [], 
        playFrom: Pages.none, 
        index: 0
      );
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
      if(context.mounted) showMessage(false, 'delFail'.tr, context);
      return false;
    }else{
      if(context.mounted){
        getAllPlayLists(context);
        showMessage(true, 'delSuccess'.tr, context);
        checkPlayListPlay(context, listId);
      }
      
      return true;
    }
  }

  // 获取某个专辑信息
  Future<Map> getAlbumData(BuildContext context, String id) async {
    final rlt=await requests.getAlbumDataRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted) showMessage(false, 'getAlbumInfoFail'.tr, context);
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
      if(context.mounted) showMessage(false, 'getArtistInfoFail'.tr, context);
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
      if(context.mounted) showMessage(false, 'searchFail'.tr, context);
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
  Future<void> playSong(BuildContext context, SongItemClass song ,Pages playFrom, int index, List<SongItemClass> list) async {
    List<SongItemClass> playList=[];
    if(playFrom==Pages.all){
      playList=songController.allSongs;
    }else if(playFrom==Pages.loved){
      playList=songController.lovedSongs.toJson();
    }else{
      playList=list;
    }
    songController.nowPlay.value=NowPlay(
      id: song.id, 
      title: song.title, 
      artist: song.artist, 
      duration: song.duration, 
      fromId: song.fromId, 
      album: song.album, 
      albumId: song.albumId, 
      artistId: song.artistId, 
      created: song.created, 
      list: playList, 
      playFrom: playFrom, 
      index: index
    );
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
    if(songController.nowPlay.value.id==''){
      return;
    }
    c.handler.stop();
    c.isPlay.value=false;
  }

  // 暂停
  void pause(){
    if(songController.nowPlay.value.id==''){
      return;
    }
    c.handler.pause();
    // c.isPlay.value=false;
  }

  // 播放
  void play(){
    if(songController.nowPlay.value.id==''){
      return;
    }
    c.handler.play();
    // c.isPlay.value=true;
  }

  // 下一首
  void skipNext(){
    if(songController.nowPlay.value.id==''){
      return;
    }
    c.handler.skipToNext();
    c.isPlay.value=true;
  }

  // 上一首
  void skipPre(){
    if(songController.nowPlay.value.id==''){
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
    if(songController.nowPlay.value.id==''){
      return;
    }
    int progress=(songController.nowPlay.value.duration*1000*val).toInt();
    c.playProgress.value=progress;
  }

  // 定位时间轴
  Future<void> seekSong(double val) async {
    if(songController.nowPlay.value.id==''){
      return;
    }
    pause();
    int progress=(songController.nowPlay.value.duration*1000*val).toInt();
    c.playProgress.value=progress;
    await seek(Duration(milliseconds: c.playProgress.value));
  }

  // 自动登录切换
  Future<void> autoLogin(bool val) async {
    c.autoLogin.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', val);
  }

  // 翻译歌词切换
  Future<void> lyricTranslate(bool val) async {
    c.lyricTranslate.value=val;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lyricTranslate', val);
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
    if(Platform.isWindows){
      await HotkeyHandler().toggleHandler();
      await HotkeyHandler().skipNextHandler();
      await HotkeyHandler().skipPreHandler();
      if(context.mounted) await HotkeyHandler().toggleLyric(context);
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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(context.mounted){
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
              const Text(
                'netPlayer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 3,),
              Text(
                'v${packageInfo.version}',
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
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: ()=>showLicensePage(
                  applicationName: 'netPlayer',
                  applicationVersion: c.version.value,
                  context: context
                ),
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
                          style: const TextStyle(
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
  }

  // 修改语言
  void selectLanguage(BuildContext context){
    String tempLang=c.lang.value;
    String langSelected=c.lang.value;
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('selectLang'.tr),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)=> DropdownButtonHideUnderline(
            child: DropdownButton2(
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
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
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              var parts = tempLang.split('_');
              var locale=Locale(parts[0], parts[1]);
              Get.updateLocale(locale);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('lang', langSelected);
              c.lang.value=langSelected;
              if(context.mounted){
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
              }
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
    if(songController.nowPlay.value.id==""){
      return;
    }
    toggleLyric(context);
    c.page.value=Pages.artist;
    final data=await getSongInfo(songController.nowPlay.value.id);
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

  // 跳转到某个专辑
  Future<void> toAlbum(BuildContext context) async {
    if(songController.nowPlay.value.id==""){
      return;
    }
    toggleLyric(context);
    c.page.value=Pages.album;
    final data=await getSongInfo(songController.nowPlay.value.id);
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

  // 文件大小计算
  String sizeConvert(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  // 获取文件夹大小
  Future<int> getDirectorySize(Directory path) async {
    int size = 0;
    for (var entity in path.listSync(recursive: true)) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    }
    return size;
  }
  
  // 清除缓存
  Future<bool> clearCache(BuildContext context) async {
    bool flag=false;
    await showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('clearCache'.tr),
        content: Text('cacheContent'.tr),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: () {
              flag=true;
              Navigator.pop(context);
            }, 
            child: Text('clear'.tr)
          )
        ],
      )
    );
    return flag;
  }

  // 歌曲长度转换
  String convertDuration(int time) {
    int hours = time ~/ 3600;
    int minutes = (time % 3600) ~/ 60;
    int seconds = time % 60;

    String formattedMin = minutes.toString().padLeft(2, '0');
    String formattedSec = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return "$hours:$formattedMin:$formattedSec";
    } else {
      return "$minutes:$formattedSec";
    }
  }

  // ISO时间转换
  String formatIsoString(String isoString) {
    try {
      DateTime dateTime = DateTime.parse(isoString).toLocal();
      String formatted = "${dateTime.year}/${dateTime.month}/${dateTime.day} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

      return formatted;
    } catch (_) {
      return "";
    }
  }

  Future<void> toggleNavidromeAPI(bool value, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value && context.mounted){
      await showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text('useNavidromeAPI'.tr),
          content: Text('enableNavidromeContent'.tr),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                prefs.setBool("useNavidrome", false);
              }, 
              child: Text('cancel'.tr)
            ),
            ElevatedButton(
              onPressed: (){
                prefs.setBool("useNavidrome", true);
                c.useNavidromeAPI.value=true;
                Navigator.pop(context);
              }, 
              child: Text(c.userInfo.value.password==null?'enableNavidromeReLogin'.tr:'enable'.tr)
            )
          ],
        )
      );
      if(c.userInfo.value.password==null){
        logout();
        return;
      }
    }else{
      c.useNavidromeAPI.value=false;
      c.authorization.value="";
      c.uniqueId.value="";
      await prefs.setBool("useNavidrome", false);
    }
    if(context.mounted) await getAllSongs(context);
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userInfo');
    stop();
    songController.nowPlay.value=NowPlay(
      id: '', 
      title: '', 
      artist: '', 
      duration: 0, 
      fromId: '', 
      album: '', 
      albumId: '', 
      artistId: '', 
      created: '', 
      list: [], 
      playFrom: Pages.none, 
      index: 0
    );
    c.userInfo.value=UserInfo(null, null, null, null, null);
    try {
      c.ws.stop();
    } catch (_) {}
  }

  Future<void> addSongToList(BuildContext context, String songId, String title) async {
    String selectedItem=playlistController.playLists[0].id;
    await showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text(
          'addToList'.tr
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)=>DropdownButtonHideUnderline(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  )
                ),
                const SizedBox(height: 10,),
                DropdownButton2(
                  isExpanded: true,
                  buttonStyleData: ButtonStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  value: selectedItem,
                  items: List.generate(playlistController.playLists.length, (index){
                    return DropdownMenuItem(
                      value: playlistController.playLists[index].id,
                      child: Text(playlistController.playLists[index].name),
                    );
                  }),
                  onChanged: (val){
                    setState((){
                      selectedItem=val as String;
                    });
                  },
                ),
              ],
            ),
          )
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('cancel'.tr)
          ),
          ElevatedButton(
            onPressed: (){
              addToList(context, songId, selectedItem);
              Navigator.pop(context);
            }, 
            child: Text('add'.tr)
          )
        ],
      )
    );
  }

}