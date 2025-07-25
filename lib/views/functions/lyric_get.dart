import 'dart:convert';

import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/requests.dart';

class LyricGet{

  HttpRequests requests=HttpRequests();
  final Controller c = Get.find();

  // 时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  Future<void> getLyric() async {
    if(!(await netease())){
      if(!(await lrclib())){
        c.lyricFrom.value=LyricFrom.none;
        c.lyric.value=[
          // {
          //   'time': 0,
          //   'content': 'noLyric'.tr,
          // }
          LyricItem('noLyric'.tr, "", 0)
        ];
        var content='noLyric'.tr;
        if(c.useWs.value){
          c.ws.sendMsg(content);
        }
      }
    }
  }

  Future<bool> lrclib() async {
    final rlt=await requests.lrclib(c.nowPlay['title'], c.nowPlay['album'], c.nowPlay['artist'], c.nowPlay['duration'].toString());
    var response=rlt['syncedLyrics']??"";
    if(response==''){
      return false;
    }
    List<LyricItem> lyricCovert=[];
    List<String> lines = LineSplitter.split(response).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        return false;
      }
      // lyricCovert.add({
      //   'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
      //   'content': line.substring(pos2 + 1).trim(),
      // });
      lyricCovert.add(LyricItem(line.substring(pos2 + 1).trim(), "", timeToMilliseconds(line.substring(pos1+1, pos2))));
    }
    c.lyric.value=lyricCovert;
    c.lyricFrom.value=LyricFrom.lrclib;
    var content='';
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    return true;
  }

  Future<bool> netease() async {
    final Map? lyricResponse=await requests.netease(c.nowPlay['title'], c.nowPlay['artist']);
    if(lyricResponse==null){
      return false;
    }
    List<LyricItem> lyricCovert=[];
    List<String> lines = LineSplitter.split(lyricResponse["lyric"]).toList();
    bool hasTranslate=lyricResponse["translate"].length!=0;
    List<String> tlines=[];
    if(hasTranslate){
      tlines=LineSplitter.split(lyricResponse["translate"]).toList();
    }
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        continue;
      }
      late int time;
      late String lyricItem;
      String lyricTranslate="";
      try {
        final timeInString=line.substring(pos1+1, pos2);
        time=timeToMilliseconds(timeInString);
        lyricItem = (pos2 + 1 < line.length) ? line.substring(pos2 + 1).trim() : "";
        if(lyricItem=='' && lyricCovert.last.lyric==''){
          continue;
        }
        if(hasTranslate){
          for(final t in tlines){
            if(t.startsWith("[$timeInString]")){
              lyricTranslate = (pos2 + 1 < t.length) ? t.substring(pos2 + 1).trim() : "";
            }
          }
        }
      } catch (_) {
        continue;
      }
      // lyricCovert.add({
      //   'time': time,
      //   'content': content,
      // });
      lyricCovert.add(LyricItem(
        lyricItem,
        lyricTranslate,
        time,
      ));
    }
    if(lyricCovert.isEmpty){
      return false;
    }
    lyricCovert.sort((a, b)=>a.time.compareTo(b.time));
    c.lyric.value=lyricCovert;
    c.lyricFrom.value=LyricFrom.netease;
    var content='';
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    return true;
  }
}