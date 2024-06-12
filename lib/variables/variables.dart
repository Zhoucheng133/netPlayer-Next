// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Controller extends GetxController{
  // 当前页面索引
  RxInt pageIndex=0.obs;
  // 当前页面Id
  RxString pageId=''.obs;
  // 页面对照
  var pages=[
    '所有歌曲',   // id: ''
    '喜欢的歌曲', // id: '' 
    '艺人',       // id: String / ''
    '专辑',       // id: String / ''
    '歌单',       // id: String / ''
    '搜索'        // id: String / ''
    '设置'        // id: ''
  ];
  // 用户信息
  RxMap<String, String?> userInfo=<String, String?>{
    'url': null,      // String?
    'username': null, // String?
    'salt': null,     // String?
    'token': null,    // String?
  }.obs;
  // 一些颜色样本，从浅色=>深色
  var color1=const Color.fromRGBO(248, 249, 255, 1);
  var color2=const Color.fromARGB(255, 238, 241, 255);
  var color3=const Color.fromARGB(255, 233, 236, 255);
  var color4=const Color.fromARGB(255, 179, 189, 252);
  var color5=const Color.fromARGB(255, 152, 166, 254);
  var color6=const Color.fromARGB(255, 120, 135, 232);
  // 所有的歌单
  RxList playLists=[].obs;
  // 现在播放信息
  RxMap<String, dynamic> nowPlay={
    'id': '',
    'title': '',
    'artist': '',
    'playFrom': '',
    'duration': 0,  // 注意这里使用的是秒~1000ms
    'fromId': '',
    'index': 0,
    'list': [],
  }.obs;
  // 播放进度, 注意单位为毫秒~1000ms=1s
  RxInt playProgress=0.obs;
  // 播放控制
  var handler;
  // 所有歌曲
  RxList allSongs=[].obs;
  // 喜欢的歌曲
  RxList lovedSongs=[].obs;
  // 是否正在播放
  RxBool isPlay=false.obs;
  // # 一些设置属性 #
  // 保存播放内容
  RxBool savePlay=true.obs;
  // 自动登录
  RxBool autoLogin=true.obs;
  // 关闭窗口后台运行
  RxBool closeOnRun=true.obs;
  // 全局快捷键
  RxBool enableShortcut=true.obs;
}