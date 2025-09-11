import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class SongItemClass{
  String id;
  String title;
  String artist;
  int duration;
  String fromId;
  String album;
  String artistId;
  String albumId;
  String created;

  // construct
  SongItemClass({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.fromId,
    required this.album,
    required this.albumId,
    required this.artistId,
    required this.created
  });

  // 反序列化
  factory SongItemClass.fromJson(Map<String, dynamic> json) {
    return SongItemClass(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      duration: json['duration'].toInt() ?? 0,
      fromId: json['fromId'] ?? '',
      album: json['album'] ?? '',
      albumId: json['albumId'] ?? '',
      artistId: json['artistId'] ?? '',
      created: json['created'] ?? json['createdAt'] ?? ''
    );
  }

  // 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'fromId': fromId,
      'album': album,
      'albumId': albumId,
      'artistId': artistId,
      'created': created
    };
  }
}

class NowPlay extends SongItemClass{
  List<SongItemClass> list;
  Pages playFrom;
  int index;

  NowPlay({
    required super.id,
    required super.title,
    required super.artist,
    required super.duration,
    required super.fromId,
    required super.album,
    required super.albumId,
    required super.artistId,
    required super.created,
    required this.list,
    required this.playFrom,
    required this.index
  });

  // 反序列化
  factory NowPlay.fromJson(Map<String, dynamic> json) {
    return NowPlay(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      duration: json['duration'] ?? 0,
      fromId: json['fromId'] ?? '',
      album: json['album'] ?? '',
      albumId: json['albumId'] ?? '',
      artistId: json['artistId'] ?? '',
      created: json['created'] ?? '',
      list: (json['list'] as List<dynamic>? ?? [])
          .map((e) => SongItemClass.fromJson(e))
          .toList(),
      playFrom: Pages.values[
          json['playFrom'] is int ? json['playFrom'] : 0],
      index: json['index'] ?? 0,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'fromId': fromId,
      'album': album,
      'albumId': albumId,
      'artistId': artistId,
      'created': created,
      'list': list.map((e) => e.toJson()).toList(),
      'playFrom': playFrom.index, // Pages 转 index
      'index': index,
    };
  }
}

class SongController extends GetxController {
  Rx<NowPlay> nowPlay=NowPlay(
    id: '', 
    title: '', 
    artist: '', 
    duration: 0, 
    fromId: '', 
    album: '', 
    albumId: '', 
    artistId: '', 
    created: '', 
    list: [], 
    playFrom: Pages.none, 
    index: 0
  ).obs;

  RxList<SongItemClass> allSongs=RxList([]);
  RxList<SongItemClass> lovedSongs=RxList([]);
}