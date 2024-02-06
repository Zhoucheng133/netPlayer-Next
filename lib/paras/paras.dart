import 'package:get/get.dart';
class Controller extends GetxController{
  var userInfo={}.obs;

  void updateUserInfo(data) => userInfo.value=data;
}