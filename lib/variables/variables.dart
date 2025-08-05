// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:smtc_windows/smtc_windows.dart';

enum LyricFrom{
  netease,
  lrclib,
  none,
}

enum Pages{
  all,      // 0 id: ''
  loved,    // 1 id: ''
  artist,   // 2 id: String / ''
  album,    // 3 id: String / ''
  playList, // 4 id: String / ''
  search,   // 5 id: String / ''
  settings, // 6 id: ''
  none,     // 7 仅作为播放来源使用
  random    // 8 仅作为播放来源使用
}

class LyricItem{
  String lyric;
  String translate;
  int time;
  LyricItem(this.lyric, this.translate, this.time);

  Map toJson()=>{
    "lyric": lyric,
    "translate": translate,
    "time": time,
  };
}

class Controller extends GetxController{
  // 是否使用桌面歌词, 仅Windows
  bool useDesktopLyric=false;
  // 当前页面索引
  Rx<Pages> page=Pages.all.obs;
  // 当前页面Id
  RxString pageId=''.obs;
  // 用户信息
  RxMap<String, String?> userInfo=<String, String?>{
    'url': null,      // String?
    'username': null, // String?
    'salt': null,     // String?
    'token': null,    // String?
  }.obs;
  // 播放进度, 注意单位为毫秒~1000ms=1s
  RxInt playProgress=0.obs;
  // 播放控制
  var handler;
  // 是否正在播放
  RxBool isPlay=false.obs;
  // 正在输入
  RxBool onInput=false.obs;
  // 播放模式, 可选值为: list, random, repeat
  RxString playMode='list'.obs;
  // 音量大小，默认为100%
  RxInt volume=100.obs;
  // 静音前的音量值
  int lastVolume=100;
  // 随机播放所有歌曲
  RxBool fullRandom=false.obs;
  // 专辑列表
  RxList albums=[].obs;
  // 艺人列表
  RxList artists=[].obs;
  // 窗口最大化
  RxBool maxWindow=false.obs;
  // 歌词内容
  RxList<LyricItem> lyric=<LyricItem>[].obs;
  // 当前歌词到多少行了
  RxInt lyricLine=0.obs;
  // ws服务
  var ws;
  RxBool onslide=false.obs;

  // 歌词来源
  Rx<LyricFrom> lyricFrom=LyricFrom.none.obs;

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
  // 歌词字号
  RxInt lyricText=17.obs;
  // 启用歌词翻译
  RxBool lyricTranslate=true.obs;

  // ws端口
  RxInt wsPort=9098.obs;
  // ws服务状态
  RxBool wsOk=true.obs;

  SMTCWindows? smtc;

  // 语言
  RxString lang='zh_CN'.obs;
  //启用歌词组件
  RxBool useLyricKit=false.obs;

  // 封面图片
  var coverFuture = Rx<Uint8List?>(null);

  // 版本号
  RxString version=''.obs;
}