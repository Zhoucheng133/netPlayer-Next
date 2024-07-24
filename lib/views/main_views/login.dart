// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/views/components/login_items.dart';
import 'package:net_player_next/views/functions/requests.dart';
import 'package:net_player_next/variables/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final Controller c = Get.put(Controller());

  TextEditingController username=TextEditingController();
  TextEditingController url=TextEditingController();
  TextEditingController password=TextEditingController();

  var mouseInButton=false;
  var isLoading=false;

  final requests=HttpRequests();

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

  Future<void> loginHandler(BuildContext context) async {
    if(url.text.isEmpty){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('URL地址不能为空'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }
    if(!url.text.startsWith('http') && !url.text.startsWith('https')){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('URL地址不合法'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }
    if(username.text.isEmpty){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('用户名不能为空'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }
    if(password.text.isEmpty){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('密码不能为空'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }
    String salt=generateRandomString(6);
    var bytes = utf8.encode(password.text+salt);
    var token = md5.convert(bytes);
    final rlt=await requests.loginRequest(url.text, username.text, salt, token.toString());
    if(rlt.isEmpty){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('网络请求失败，请检查你的网络和服务器运行状态'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }else if(rlt['subsonic-response']['status']=='failed'){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('用户名或者密码错误'),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text('好的')
            )
          ],
        ),
      );
      return;
    }
    c.userInfo.value={
      'url': url.text,
      'username': username.text,
      'salt': salt,
      'token': token.toString(),
    };
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(c.userInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 450,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 253, 253),
          borderRadius: BorderRadius.circular(10),
           boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(150, 200, 200, 200),
              offset: Offset(0, 0),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10,),
                      const Icon(
                        // FluentIcons.chevron_right_med,
                        Icons.chevron_right_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        "连接到你的音乐库",
                        style: GoogleFonts.notoSansSc(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // URL地址输入框
                        URLInput(controller: url, loginHandler: ()=>loginHandler(context),),
                        const SizedBox(height: 20,),
                        // 用户名输入框
                        UserNameInput(controller: username, loginHandler: ()=>loginHandler(context),),
                        const SizedBox(height: 20,),
                        // 密码输入框
                        PasswordInput(controller: password, loginHandler: ()=>loginHandler(context),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 40,)
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  loginHandler(context);
                },
                child: MouseRegion(
                  onEnter: (event){
                    setState(() {
                      mouseInButton=true;
                    });
                  },
                  onExit: (event){
                    setState(() {
                      mouseInButton=false;
                    });
                  },
                  cursor: isLoading ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                  child: AnimatedContainer(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: mouseInButton ? c.color3 : c.color2,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10)
                      )
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: c.color5,
                      ),
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}