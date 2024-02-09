import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void updateUserInfo(data) => userInfo.value=data;
  void updateNowPage(data) => nowPage.value=data;
  void updateAllPlayList(data) => allPlayList.value=data;
  void updateSelectedListName(data) => selectedListName.value=data;
  void updateShowLyric(data) => showLyric.value=data;
  void updateAllAlbums(data) => allAlbums.value=data;
  void updateAllArtists(data) => allArtists.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updateLovedSongs(data) => lovedSongs.value=data;

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
}