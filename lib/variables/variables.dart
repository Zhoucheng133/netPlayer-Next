import 'package:get/get.dart';
class Controller extends GetxController{
  // 当前页面
  var pageNow={
    // 索引
    'index': 0,
    // id号
    'id': null,
  }.obs;
  // 页面对照
  var pages=[
    '所有歌曲', // id: null
    '艺人',     // id: String?
    '专辑',     // id: String?
    '歌单',     // id: String?
    '搜索'      // id: String?
  ];
  var userInfo={
    'username': null, // String?
    'password': null, // String?
  };
}