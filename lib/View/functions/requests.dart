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
}