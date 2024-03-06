// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

Future<void> showLicenseDialog(BuildContext context) async {
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text("版权信息"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("netPlayer"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text("Flutter"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("window_manager"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("get"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("flutter_launcher_icons"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("package_info_plus"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("crypto"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("audio_service"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("hotkey_manager"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("http"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("media_kit"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("scroll_to_index"),
              Expanded(child: Container()),
              Text("MIT"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("shared_preferences"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("url_launcher"),
              Expanded(child: Container()),
              Text("BSD-3"),
              SizedBox(width: 5,),
            ],
          ),
          Row(
            children: [
              Text("flash"),
              Expanded(child: Container()),
              Text("Apache-2"),
              SizedBox(width: 5,),
            ],
          ),
        ],
      ),
      actions: [
        FilledButton(
          child: Text("完成"), 
          onPressed: (){
            Navigator.pop(context);
          }
        )
      ],
    )
  );
}

void showUpdaterDialog(bool needUpdate, BuildContext context){
  showFlash(
    duration: const Duration(milliseconds: 1500),
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200), 
    builder: (context, controller) => FlashBar(
      behavior: FlashBehavior.floating,
      position: FlashPosition.top,
      backgroundColor: needUpdate ? Colors.orange : Colors.green[400],
      iconColor: Colors.white,
      margin: EdgeInsets.only(
        top: 30,
        left: (MediaQuery.of(context).size.width-280)/2,
        right: (MediaQuery.of(context).size.width-280)/2
      ),
      icon: Icon(
        Icons.info_outline_rounded,
      ),
      controller: controller, 
      content: Text(
        needUpdate ? "有可用的更新" : "已是最新版本",
        style: TextStyle(
          color: Colors.white
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    context: context
  );
}

void showUpdaterErrorDialog(BuildContext context){
  showFlash(
    duration: const Duration(milliseconds: 1500),
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200), 
    builder: (context, controller) => FlashBar(
      behavior: FlashBehavior.floating,
      position: FlashPosition.top,
      backgroundColor: Colors.red,
      iconColor: Colors.white,
      margin: EdgeInsets.only(
        top: 30,
        left: (MediaQuery.of(context).size.width-280)/2,
        right: (MediaQuery.of(context).size.width-280)/2
      ),
      icon: Icon(
        Icons.close,
      ),
      controller: controller, 
      content: Text(
        "请求失败",
        style: TextStyle(
          color: Colors.white
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    context: context
  );
}