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

  void updateUserInfo(data) => userInfo.value=data;
  void updateNowPage(data) => nowPage.value=data;
  void updateAllPlayList(data) => allPlayList.value=data;
  void updateSelectedListName(data) => selectedListName.value=data;
}