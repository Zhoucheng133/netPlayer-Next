import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/functions/operations.dart';
import 'package:net_player_next/views/functions/requests.dart';

class Infos {

  final requests=HttpRequests();
  final Controller c = Get.find();
  final Operations operations=Operations();

  // 歌曲信息
  void songInfo(BuildContext context, Map data){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text('songInfo'.tr,),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${data['id']}",
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'songTitle'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          FlutterClipboard.copy(data['title']).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data['title'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'duration'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data['duration'],
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'artist'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          FlutterClipboard.copy(data['artist']).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data['artist'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'album'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          FlutterClipboard.copy(data['album']).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data['album'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'songId'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          FlutterClipboard.copy(data['id']).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data['id'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'playlistId'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: MouseRegion(
                      cursor: data['listId']!=null && data['listId'].length!=0 ? SystemMouseCursors.click : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onTap: (){
                          if(data['listId']!=null && data['listId'].length!=0){
                            FlutterClipboard.copy(data['listId']).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          }
                        },
                        child: Text(
                          data['listId']??"N/A",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'created'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operations.formatIsoString(data['created']),
                    )
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      )
    );
  }
}