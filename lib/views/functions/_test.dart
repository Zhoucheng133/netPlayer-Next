import 'dart:convert';

import 'package:http/http.dart' as http;
Future<void> main(List<String> args) async {
  String id="";
  try {
    const keyword="星月夜 由薫";
    const searchAPI="https://music.163.com/api/search/get/web?csrf_token=hlpretag=&hlposttag=&s=$keyword&type=1&offset=0&total=true&limit=1";
    final response=await http.get(Uri.parse(searchAPI));
    id=json.decode(utf8.decode(response.bodyBytes))['result']['songs'][0]['id'].toString();
  } catch (_) {}
  if(id.isEmpty){
    return;
  }
  String lyric="";
  try {
    final lyricAPI="https://music.163.com/api/song/media?id=$id";
    final response=await http.get(Uri.parse(lyricAPI));
    // print(json.decode(utf8.decode(response.bodyBytes)))
    lyric=json.decode(utf8.decode(response.bodyBytes))["lyric"];
  } catch (_) {}
  print(lyric);
}