import 'dart:convert';

import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/requests.dart';

class LyricGet{

  HttpRequests requests=HttpRequests();
  final Controller c = Get.put(Controller());

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
        c.lyric.value=[
          {
            'time': 0,
            'content': 'noLyric'.tr,
          }
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
    List lyricCovert=[];
    List<String> lines = LineSplitter.split(response).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        return false;
      }
      lyricCovert.add({
        'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
        'content': line.substring(pos2 + 1).trim(),
      });
    }
    c.lyric.value=lyricCovert;
    var content='';
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    return true;
  }

  Future<bool> netease() async {
    final String? lyricPainText=await requests.netease(c.nowPlay['title'], c.nowPlay['artist']);
    if(lyricPainText==null){
      return false;
    }
    // print(lyricPainText);
    List lyricCovert=[];
    List<String> lines = LineSplitter.split(lyricPainText).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        continue;
      }
      late int time;
      late String content;
      try {
        time=timeToMilliseconds(line.substring(pos1+1, pos2));
        content=line.substring(pos2 + 1).trim();
      } catch (_) {
        continue;
      }
      lyricCovert.add({
        'time': time,
        'content': content,
      });
    }
    if(lyricCovert.isEmpty){
      return false;
    }
    lyricCovert.sort((a, b)=>a['time'].compareTo(b['time']));
    c.lyric.value=lyricCovert;
    var content='';
    if(c.useWs.value){
      c.ws.sendMsg(content);
    }
    return true;
  }
}