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
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('请求所有歌单失败'),
          content: const Text('请检查你的网络或者服务器运行状态'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        )
      );
      return;
    }else{
      try {
        c.playLists.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {}
    }
  }

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

  Future<void> delPlayList(BuildContext context, String id,) async {
    final rlt=await requests.delPlayListRequest(id);
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      showMessage(false, '删除歌单失败', context);
      return;
    }else{
      showMessage(true, '删除歌单成功', context);
      getAllPlayLists(context);
    }
  }
}