import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Controller extends GetxController{
  // 当前页面
  var pageNow={
    // 索引
    'index': 0,
    // id号
    'id': null,
  }.obs;
  // 页面对照
  var pages=[
    '所有歌曲', // id: null
    '艺人',     // id: String?
    '专辑',     // id: String?
    '歌单',     // id: String?
    '搜索'      // id: String?
  ];
  // 用户信息
  var userInfo={
    'url': null,      // String?
    'username': null, // String?
    'salt': null,     // String?
    'token': null,    // String?
  }.obs;
  // 一些颜色样本，从浅色=>深色
  var color1=const Color.fromRGBO(248, 249, 255, 1);
  var color2=const Color.fromARGB(255, 238, 241, 255);
  var color3=const Color.fromARGB(255, 233, 236, 255);
  var color4=const Color.fromARGB(255, 179, 189, 252);
}