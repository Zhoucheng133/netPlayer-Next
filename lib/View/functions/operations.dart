// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/message.dart';
import 'package:net_player_next/View/functions/requests.dart';
import 'package:net_player_next/variables/variables.dart';

class Operations{
  final requests=HttpRequests();
  final Controller c = Get.put(Controller());

  // 获取所有的歌单
  Future<void> getAllPlayLists(BuildContext context) async {
    final rlt=await requests.playListsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取歌单失败', context);
      return;
    }else{
      try {
        c.playLists.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {}
    }
  }

  // 添加歌单
  Future<void> addPlayList(BuildContext context, String name) async {
    if(name.isEmpty){
      showMessage(false, '歌单名称不能为空', context);
    }else{
      final rlt=await requests.createPlayListRequest(name);
      Navigator.pop(context);
      if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
        showMessage(false, '创建歌单失败', context);
      }else{
        showMessage(true, '创建歌单成功', context);
      }
      getAllPlayLists(context);
    }
  }

  // 重命名歌单
  Future<void> renamePlayList(BuildContext context, String id, String name) async {
    final rlt=await requests.renameList(id, name);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '重命名歌单失败', context);
      return;
    }else{
      showMessage(true, '重命名歌单成功', context);
      getAllPlayLists(context);
    }
  }

  // 删除歌单
  Future<void> delPlayList(BuildContext context, String id) async {
    final rlt=await requests.delPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '删除歌单失败', context);
      return;
    }else{
      showMessage(true, '删除歌单成功', context);
      getAllPlayLists(context);
    }
  }

  // 获取所有歌曲
  Future<void> getAllSongs(BuildContext context) async {
    final rlt=await requests.getAllSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取所有歌曲失败', context);
      return;
    }else{
      try {
        var tmpList=rlt['subsonic-response']['randomSongs']['song'];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        c.allSongs.value=tmpList;
      } catch (_) {
        showMessage(false, '解析所有歌曲失败', context);
        return;
      }
    }
  }

  // 获取喜欢的歌曲
  Future<void> getLovedSongs(BuildContext context) async {
    final rlt=await requests.getLovedSongsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '获取喜欢的歌曲失败', context);
      return;
    }else{
      try {
        if(rlt['subsonic-response']['starred']['song']==null){
          return;
        }else{
          c.lovedSongs.value=rlt['subsonic-response']['starred']['song'];
        }
      } catch (_) {
        showMessage(false, '解析喜欢的歌曲失败', context);
        return;
      }
    }
  }

  // 播放歌曲
  void playSong(BuildContext context, String id, String title, String artist, String playFrom, int duration, String listId, int index){
    Map<String, Object> value={
      'id': id,
      'title': '3分30秒のタイムカプセル',
      'artist': '测试用的艺人',
      'playFrom': playFrom,
      'duration': 0,
      'fromId': '',
      'index': 0,
      // TODO 需要修改list
      'list': [],
    };
    c.nowPlay.value=value;
    c.handler.play();
  }
}