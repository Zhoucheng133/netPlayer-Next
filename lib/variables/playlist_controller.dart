import 'package:get/get.dart';

class PlayListItem{
  String name;
  String id;
  int songCount;
  String created;
  String changed;
  PlayListItem(this.name, this.id, this.songCount, this.created, this.changed);

  factory PlayListItem.fromJson(Map<String, dynamic> json){
    return PlayListItem(
      json['name']??"", 
      json['id']??"", 
      json['songCount']??0, 
      json['created']??"", 
      json['changed']??""
    );
  }
}

class PlaylistController extends GetxController {
  RxList<PlayListItem> playLists=RxList<PlayListItem>([]);
}