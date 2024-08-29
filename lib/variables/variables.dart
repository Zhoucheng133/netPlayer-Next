// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smtc_windows/smtc_windows.dart';
class Controller extends GetxController{
  // 当前软件版本
  String version='3.2.3';
  // 当前页面索引
  RxInt pageIndex=0.obs;
  // 当前页面Id
  RxString pageId=''.obs;
  // 页面对照
  var pages=[
    'all',      // id: ''
    'loved',    // id: '' 
    'artist',   // id: String / ''
    'album',    // id: String / ''
    'playList', // id: String / ''
    'search'    // id: String / ''
    'settings'  // id: ''
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
    'album': '',
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
  // 正在输入
  RxBool onInput=false.obs;
  // 播放模式, 可选值为: list, random, repeat
  RxString playMode='list'.obs;
  // 音量大小，默认为100%
  RxInt volume=100.obs;
  // 随机播放所有歌曲
  RxBool fullRandom=false.obs;
  // 专辑列表
  RxList albums=[].obs;
  // 艺人列表
  RxList artists=[].obs;
  // 窗口最大化
  RxBool maxWindow=false.obs;
  // 歌词内容
  RxList lyric=[].obs;
  // 当前歌词到多少行了
  RxInt lyricLine=0.obs;
  // ws服务
  var ws;
  RxBool onslide=false.obs;

  // # 一些设置属性 #
  // 保存播放内容
  RxBool savePlay=true.obs;
  // 自动登录
  RxBool autoLogin=true.obs;
  // 关闭窗口后台运行
  RxBool closeOnRun=true.obs;
  // 全局快捷键
  RxBool useShortcut=true.obs;
  // 显示歌词
  RxBool showLyric=false.obs;
  // 启用ws服务
  RxBool useWs=false.obs;

  // 更新音量
  void updateVolume(int val) {
    volume.value=val;
  }

  // ws端口
  RxInt wsPort=9098.obs;
  // ws服务状态
  RxBool wsOk=true.obs;
  
  late SMTCWindows smtc;

  // 语言
  RxString lang='en_US'.obs;
}