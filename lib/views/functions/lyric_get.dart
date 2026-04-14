import 'dart:convert';

import 'package:get/get.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/functions/requests.dart';

class LyricGet{

  HttpRequests requests=HttpRequests();
  final Controller c = Get.find();
  final SongController songController=Get.find();

  // 时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts.length>1 ? secondsParts[1] : "0");

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  Future<void> getLyric() async {
    if(!(await netease())){
      if(!(await lrclib())){
        c.lyricFrom.value=LyricFrom.none;
        c.lyric.value=[
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
    final rlt=await requests.lrclib(songController.nowPlay.value.title, songController.nowPlay.value.album, songController.nowPlay.value.artist, songController.nowPlay.value.duration.toString());
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
    final Map? lyricResponse=await requests.netease(songController.nowPlay.value.title, songController.nowPlay.value.artist);
    if(lyricResponse==null){
      return false;
    }
    String lyricRaw = lyricResponse["lyric"];
    String translateRaw = lyricResponse["translate"] ?? "";

    final timeRegex = RegExp(r'\[(\d{2}:\d{2}(?:\.\d+)?)\]');

    Map<String, String> translateMap = {};
    List<String> tLines = LineSplitter.split(translateRaw).toList();
    for (var line in tLines) {
      var match = timeRegex.firstMatch(line);
      if (match != null) {
        String timeStr = match.group(1)!;
        String content = line.replaceAll(timeRegex, "").trim();
        translateMap[timeStr.split('.')[0]] = content;
      }
    }

    List<LyricItem> lyricCovert = [];
    List<String> lines = LineSplitter.split(lyricRaw).toList();

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      Iterable<RegExpMatch> matches = timeRegex.allMatches(line);
      if (matches.isEmpty) continue;

      String content = line.replaceAll(timeRegex, "").trim();

      for (var m in matches) {
        String timeInString = m.group(1)!;
        try {
          int timeMs = timeToMilliseconds(timeInString);
          String pureTimeKey = timeInString.split('.')[0];
          String lyricTranslate = translateMap[pureTimeKey] ?? "";

          lyricCovert.add(LyricItem(content, lyricTranslate, timeMs));
        } catch (_) {
          continue;
        }
      }
    }
    lyricCovert.sort((a, b) => a.time.compareTo(b.time));
    lyricCovert.removeWhere((item) => item.lyric.isEmpty && item.translate.isEmpty);
    
    if (lyricCovert.isEmpty) return false;
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