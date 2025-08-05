import 'package:get/get.dart';

class PlayListItemClass{
  String name;
  String id;
  int songCount;
  String created;
  String changed;
  int duration;
  PlayListItemClass(this.name, this.id, this.songCount, this.created, this.changed, this.duration);

  factory PlayListItemClass.fromJson(Map<String, dynamic> json){
    return PlayListItemClass(
      json['name']??"", 
      json['id']??"", 
      json['songCount']??0, 
      json['created']??"", 
      json['changed']??"",
      json['duration']??0,
    );
  }
}

class PlaylistController extends GetxController {
  RxList<PlayListItemClass> playLists=RxList<PlayListItemClass>([]);
}