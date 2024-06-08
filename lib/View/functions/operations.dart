import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/functions/requests.dart';
import 'package:net_player_next/variables/variables.dart';

class Operations{
  final requests=HttpRequests();
  final Controller c = Get.put(Controller());

  Future<void> getAllPlayLists(BuildContext context) async {
    final rlt=await requests.playListsRequest();
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
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
      });
      return;
    }else{
      try {
        c.playLists.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {}
    }
  }
}