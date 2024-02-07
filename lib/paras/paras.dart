import 'package:get/get.dart';
class Controller extends GetxController{
  var userInfo={}.obs;
  var nowPage={
    "name": "所有歌曲",
    "id": "",
  }.obs;

  void updateUserInfo(data) => userInfo.value=data;
  void updateNowPage(data) => nowPage.value=data;
}