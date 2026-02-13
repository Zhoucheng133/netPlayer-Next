import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/album_controller.dart';
import 'package:net_player_next/variables/song_controller.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:net_player_next/views/components/message.dart';
import 'package:net_player_next/views/functions/operations.dart';

class Infos {

  final Controller c = Get.find();
  final Operations operations=Operations();

  // 专辑信息
  Future<void> albumInfo(BuildContext context, AlbumItemClass data) async {
    if(data.coverArt.isEmpty){
      Map rlt=await operations.getAlbumData(context, data.id);
      data.coverArt=rlt['coverArt'];
    }
    if(context.mounted){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: Text('albumInfo'.tr),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "${c.userInfo.value.url}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${data.coverArt}",
                    width: 100,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'albumTitle'.tr,
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
                            FlutterClipboard.copy(data.title).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          },
                          child: Text(
                            data.title,
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
                            FlutterClipboard.copy(data.artist).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          },
                          child: Text(
                            data.artist,
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
                        'songCount'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.songCount.toString(),
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
                        'albumId'.tr,
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
                            FlutterClipboard.copy(data.id).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          },
                          child: Text(
                            data.id,
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
                        'totalDuration'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operations.convertDuration(data.duration),
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
                        'year'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        data.year==0 ? "N/A" : data.year.toString(),
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
                        operations.formatIsoString(data.created),
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
        ),
      );
    }
  }

  // 歌曲信息
  void songInfo(BuildContext context, SongItemClass data){
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
                  "${c.userInfo.value.url}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo.value.username}&t=${c.userInfo.value.token}&s=${c.userInfo.value.salt}&id=${data.id}",
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
                          FlutterClipboard.copy(data.title).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data.title,
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
                      operations.convertDuration(data.duration),
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
                          FlutterClipboard.copy(data.artist).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data.artist,
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
                          FlutterClipboard.copy(data.album).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data.album,
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
                          FlutterClipboard.copy(data.id).then((_){
                            if(context.mounted){
                              showMessage(true, 'copied'.tr, context);
                            }
                          });
                        },
                        child: Text(
                          data.id,
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
                      cursor: data.fromId.isNotEmpty ? SystemMouseCursors.click : SystemMouseCursors.basic,
                      child: GestureDetector(
                        onTap: (){
                          if(data.fromId.isNotEmpty){
                            FlutterClipboard.copy(data.fromId).then((_){
                              if(context.mounted){
                                showMessage(true, 'copied'.tr, context);
                              }
                            });
                          }
                        },
                        child: Text(
                          data.fromId.isNotEmpty? data.fromId : "N/A",
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
                      operations.formatIsoString(data.created),
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