import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Requests{
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
  void loginRequest(String url, String username, String salt, String token){
    
  }
}