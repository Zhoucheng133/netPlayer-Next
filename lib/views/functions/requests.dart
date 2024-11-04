import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:net_player_next/variables/variables.dart';

class HttpRequests{
  final Controller c = Get.put(Controller());
  // 请求函数
  Future<Map<String, dynamic>> httpRequest(String url, {int timeoutInSeconds = 5}) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeoutInSeconds));

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> data = json.decode(responseBody);
        return data;
      } else {
        Map<String, dynamic> data = {};
        // throw Exception(data);
        return data;
      }
    } on TimeoutException {
      // 请求超时处理逻辑
      Map<String, dynamic> data = {};
      return data;
    } catch (error) {
      // 其他错误处理逻辑
      Map<String, dynamic> data = {};
      return data;
    }
  }
  // 登录请求
  Future<Map> loginRequest(String url, String username, String salt, String token) async {
    return await httpRequest("$url/rest/ping.view?v=1.12.0&c=myapp&f=json&u=$username&t=$token&s=$salt");
  }
  // 所有歌单请求
  Future<Map> playListsRequest() async {
    return await httpRequest("${c.userInfo['url']}/rest/getPlaylists?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo['username']}&t=${c.userInfo['token']}&s=${c.userInfo['salt']}");
  }
  // 新建歌单
  Future<Map> createPlayListRequest(String name) async {
    return await httpRequest("${c.userInfo["url"]}/rest/createPlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&name=$name");
  }
  // 删除歌单
  Future<Map> delPlayListRequest(String id) async {
    return await httpRequest("${c.userInfo["url"]}/rest/deletePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id");
  }
  // 重命名歌单
  Future<Map> renameList(String id, String name) async {
    return await httpRequest("${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=$id&name=$name");
  }
  // 获取所有歌曲
  Future<Map> getAllSongsRequest() async {
    return await httpRequest("${c.userInfo["url"]}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&size=500");
  }
  // 获取喜欢的歌曲
  Future<Map> getLovedSongsRequest() async {
    return await httpRequest("${c.userInfo["url"]}/rest/getStarred?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}");
  }
  // 获取指定id的歌单
  Future<Map> getPlayListRequest(String id) async {
    return await httpRequest("${c.userInfo["url"]}/rest/getPlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id");
  }
  // 喜欢某个歌曲
  Future<Map> loveSongRequest(String id) async {
    return await httpRequest('${c.userInfo["url"]}/rest/star?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id');
  }
  // 取消喜欢某个歌曲
  Future<Map> deLoveSongRequest(String id) async {
    return await httpRequest('${c.userInfo["url"]}/rest/unstar?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id');
  }
  // 将某首歌添加到某个歌单
  Future<Map> addToListRequest(String songId, String listId) async {
    return await httpRequest('${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=$listId&songIdToAdd=$songId');
  }
  // 随机获取一首歌
  Future<Map> getRandomSongRequest() async {
    return await httpRequest("${c.userInfo["url"]}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&size=1");
  }
  // 从歌单中删除
  Future<Map> delFromListRequest(String listId, int songIndex) async {
    return await httpRequest('${c.userInfo["url"]}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&playlistId=$listId&songIndexToRemove=$songIndex');
  }
  // 获取所有专辑
  Future<Map> getAlbumsRequest() async {
    return await httpRequest("${c.userInfo["url"]}/rest/getAlbumList?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&type=newest&size=500");
  }
  // 获取所有艺人
  Future<Map> getArtistRequest() async {
    return await httpRequest('${c.userInfo["url"]}/rest/getArtists?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}');
  }
  // 获取专辑信息
  Future<Map> getAlbumDataRequest(String id) async {
    return await httpRequest("${c.userInfo["url"]}/rest/getAlbum?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id");
  }
  // 获取艺人信息
  Future<Map> getArtistDataRequest(String id) async {
    return await httpRequest('${c.userInfo["url"]}/rest/getArtist?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id');
  }
  // 搜索
  Future<Map> searchRequest(String value) async {
    return await httpRequest('${c.userInfo["url"]}/rest/search2?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&query=$value');
  }
  // 刷新音乐库
  Future<Map> refreshLibrary() async {
    return await httpRequest('${c.userInfo["url"]}/rest/startScan?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}');
  }
  // 从lrclib获取歌词
  Future<Map> lrclib(String title, String album, String artist, String duration) async {
    return await httpRequest('https://lrclib.net/api/get?artist_name=$artist&track_name=$title&album_name=$album&duration=$duration');
  }
  // 从网易云获取歌词
  Future<String?>  netease(String title, String artist) async {
    String id="";
    try {
      final keyword="$title $artist";
      final searchAPI="https://music.163.com/api/search/get/web?csrf_token=hlpretag=&hlposttag=&s=$keyword&type=1&offset=0&total=true&limit=1";
      final response=await http.get(Uri.parse(searchAPI));
      // print(searchAPI);
      
      final firstRlt=json.decode(utf8.decode(response.bodyBytes))['result']['songs'][0];
      // print("${firstRlt['name']} $title");
      // print("ARTIST: ${firstRlt['artists']['name']}");
      if(!(firstRlt['name'].contains(title))){
        return null;
      }
      id=json.decode(utf8.decode(response.bodyBytes))['result']['songs'][0]['id'].toString();
    } catch (_) {
      return null;
    }
    if(id.isEmpty){
      return null;
    }
    String lyric="";
    try {
      final lyricAPI="https://music.163.com/api/song/media?id=$id";
      final response=await http.get(Uri.parse(lyricAPI));
      lyric=json.decode(utf8.decode(response.bodyBytes))["lyric"];
    } catch (_) {
      return null;
    }
    if(lyric.isNotEmpty){
      return lyric;
    }
    return null;
  }
  // 获取某个歌曲信息
  Future<Map> getSong(String id) async {
    return await httpRequest('${c.userInfo["url"]}/rest/getSong?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=$id');
  }
}