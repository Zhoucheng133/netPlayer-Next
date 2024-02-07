// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

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

// 获取随机数
String generateRandomString(int length) {
  const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  Random random = Random();
  String result = "";

  for (int i = 0; i < length; i++) {
    int randomIndex = random.nextInt(charset.length);
    result += charset[randomIndex];
  }

  return result;
}

// 自动登录请求
Future<Map> autoLoginRequest(String url, String username, String salt, String token) async {
  if(url.endsWith("/")){
    url=url.substring(0, url.length - 1);
  }
  Map response=await httpRequest("${url}/rest/ping.view?v=1.12.0&c=myapp&f=json&u=${username}&t=${token}&s=${salt}");
  if(response.isEmpty){
    return {"status": "URL Err"};
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return {"status": "URL Err"};
  }
  response["url"]=url;
  response["username"]=username;
  response["salt"]=salt;
  response["token"]=token.toString();
  return response;
}


// 登录请求
Future<Map> loginRequest(String url, String username, String password) async {
  if(url.endsWith("/")){
    url=url.substring(0, url.length - 1);
  }
  String salt=generateRandomString(6);
  var bytes = utf8.encode(password+salt);
  var token = md5.convert(bytes);
  Map response=await httpRequest("${url}/rest/ping.view?v=1.12.0&c=myapp&f=json&u=${username}&t=${token}&s=${salt}");
  if(response.isEmpty){
    return {"status": "URL Err"};
  }
  try{
    response=response["subsonic-response"];
  }catch(e){
    return {"status": "URL Err"};
  }
  response["url"]=url;
  response["username"]=username;
  response["salt"]=salt;
  response["token"]=token.toString();
  return response;
}

Future<void> main(List<String> args) async {
  
}