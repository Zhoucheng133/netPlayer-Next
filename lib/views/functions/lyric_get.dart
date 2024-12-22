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
    // print("get!");
    if(!(await subsonic())) {
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

  Future<bool> subsonic() async {
    final rlt=await requests.subsonic(c.nowPlay['id']);
    var response=rlt['subsonic-response']['lyricsList']['structuredLyrics'][0]['line'] ?? [];
    if(response == []) {
      return false;
    }
    List lyricCovert=[];
    // 遍历每一行歌词
    for (var line in response) {
      int time = line['start']; // 时间戳
      String content = line['value'].trim(); // 歌词内容

      // 检查歌词内容是否为空
      if (content.isNotEmpty) {
        lyricCovert.add({
          'time': time, // 歌词出现的时间（毫秒）
          'content': content, // 歌词文本
        });
      }
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
        content = (pos2 + 1 < line.length) ? line.substring(pos2 + 1).trim() : "";
        if(content=='' && lyricCovert.last['content']==''){
          continue;
        }
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