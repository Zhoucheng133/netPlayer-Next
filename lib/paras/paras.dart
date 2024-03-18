// ignore_for_file: prefer_const_constructors, avoid_init_to_null, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/request.dart';
class Controller extends GetxController{
  // 各种颜色
  var primaryColor=const Color.fromARGB(255, 0, 97, 164);
  var hoverColor=const Color.fromARGB(255, 20, 109, 171);

  // 用户信息
  var userInfo={}.obs;
  // 当前页面，注意，默认情况下id为空
  var nowPage={
    "name": "所有歌曲",
    "id": "",
  }.obs;
  // 所有的歌单
  var allPlayList=[].obs;
  // 选择的歌单名称
  var selectedListName="".obs;
  // 显示歌词
  var showLyric=false.obs;
  // 播放进度(以毫秒计算)
  var playProgress=0.obs;
  // 是否在播放
  var isPlay=false.obs;
  // 播放模式
  var playMode="顺序播放".obs;
  // 完全随机播放
  var fullRandomPlay=false.obs;
  // 当前歌词到第几行了
  var lyricLine=0.obs;
  // 歌词
  var lyric=[].obs;

  var handler;

  var playInfo={}.obs;
  var playInfo_example={
    "playFrom": "所有歌曲",
    "id": "songId",
    "title": "songTitle",
    "artist": "ryan",
    "duration": 1234,
    "listId": "abcd",
    "index": 0,
    "list": [],
    "album": "albumName"
  };

  // 所有专辑
  var allAlbums=[].obs;
  // 所有艺人
  var allArtists=[].obs;
  // 所有歌曲
  var allSongs=[].obs;
  // 喜欢的歌曲 => 注意及时刷新
  var lovedSongs=[].obs;

  // 设置部分
  var savePlay=true.obs;
  var autoLogin=true.obs;

  // 是否聚焦在输入框上
  var focusTextField=false.obs;

  // 专辑信息
  var albumContentData={}.obs;

  // 将时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  // 是否在滑动进度条
  var onSlide=false.obs;
  
  // 关闭窗口隐藏
  var hideOnClose=true.obs;

  // 窗口是否聚焦
  var windowFocus=true.obs;

  void updateWindowFocus(data) => windowFocus.value=data;
  void updateOnSlide(data) => onSlide.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateNowPage(data) => nowPage.value=data;
  void updateAllPlayList(data) => allPlayList.value=data;
  void updateSelectedListName(data) => selectedListName.value=data;
  void updateShowLyric(data) => showLyric.value=data;
  void updateAllAlbums(data) => allAlbums.value=data;
  void updateAllArtists(data) => allArtists.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updateLovedSongs(data) => lovedSongs.value=data;
  void updateLyricLine(data) => lyricLine.value=data;
  void updatePlayProgress(data){
    playProgress.value=data;
    if(lyric.isNotEmpty && lyric.length!=1){
      for (var i = 0; i < lyric.length; i++) {
        if(i==lyric.length-1){
          updateLyricLine(lyric.length);
          break;
        }else if(i==0 && data<lyric[i]['time']){
          updateLyricLine(0);
          break;
        }else if(data>=lyric[i]['time'] && data<lyric[i+1]['time']){
          updateLyricLine(i+1);
          break;
        }
      }
    }else if(lyric.length==1){
      updateLyricLine(0);
    }
  }
  Future<void> updatePlayInfo(data) async {
    playInfo.value=data; 
    lyric.value=[
      {
        'time': 0,
        'content': '正在查找歌词...',
      }
    ];
    String lyricPain=await getLyric(data['title'], data['album'], data['artist'], data['duration'].toString());
    if(lyricPain=='没有找到歌词'){
      lyric.value=[
        {
          'time': 0,
          'content': '没有找到歌词',
        }
      ];
      return;
    }
    List lyricCovert=[];
    List<String> lines = LineSplitter.split(lyricPain).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      lyricCovert.add({
        'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
        'content': line.substring(pos2 + 1).trim(),
      });
    }
    lyric.value=lyricCovert;
  }
  void updateIsPlay(data) => isPlay.value=data;
  Future<void> updatePlayMode(data) async {
    playMode.value=data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("playMode", data);
  }
  void updateFocusTextField(data) => focusTextField.value=data;
  void updateAlbumContentData(data) => albumContentData.value=data;
  void updateFullRandomPlay(data) => fullRandomPlay.value=data;

  Future<void> updateSavePlay(data) async {
    savePlay.value=data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("savePlay", data);
  }
  Future<void> updateAutoLogin(data) async {
    autoLogin.value=data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("autoLogin", data);
  }
  Future<void> updateHideOnClose(data) async {
    hideOnClose.value=data;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hideOnClose", data);
  }
}