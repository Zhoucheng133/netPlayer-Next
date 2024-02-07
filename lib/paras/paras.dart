import 'package:get/get.dart';
class Controller extends GetxController{
  var userInfo={}.obs;
  // 当前页面，注意，默认情况下id为空
  var nowPage={
    "name": "所有歌曲",
    "id": "",
  }.obs;

  void updateUserInfo(data) => userInfo.value=data;
  void updateNowPage(data) => nowPage.value=data;
}