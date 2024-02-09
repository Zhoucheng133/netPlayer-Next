import 'package:get/get.dart';
class Controller extends GetxController{
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

  void updateSavePlay(data) => savePlay.value=data;
  void updateAutoLogin(data) => autoLogin.value=data;
}