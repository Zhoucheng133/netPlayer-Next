import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';
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

  final Controller c = Get.find();
  final ColorController colorController=Get.find();

  TextEditingController username=TextEditingController();
  TextEditingController url=TextEditingController();
  TextEditingController password=TextEditingController();

  var mouseInButton=false;
  bool isLoading=false;

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

  String normalizeUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  Future<void> loginHandler(BuildContext context) async {
    if(url.text.isEmpty){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('loginFail'.tr),
          content: Text('urlEmpty'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
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
          title: Text('loginFail'.tr),
          content: Text('urlInvalid'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
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
          title: Text('loginFail'.tr),
          content: Text('usernameEmpty'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
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
          title: Text('loginFail'.tr),
          content: Text('passwordEmpt'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
            )
          ],
        ),
      );
      return;
    }
    setState(() {
      isLoading=true;
    });
    String salt=generateRandomString(6);
    var bytes = utf8.encode(password.text+salt);
    var token = md5.convert(bytes);
    final rlt=await requests.loginRequest(normalizeUrl(url.text), username.text, salt, token.toString());
    if(rlt.isEmpty && context.mounted){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('loginFail'.tr),
          content: Text('loginConnectFail'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
            )
          ],
        ),
      );
      return;
    }else if(rlt['subsonic-response']['status']=='failed' && context.mounted){
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text('loginFail'.tr),
          content: Text('passwordErr'.tr),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('ok'.tr)
            )
          ],
        ),
      );
      return;
    }
    c.userInfo.value=UserInfo(normalizeUrl(url.text), username.text, salt, token.toString(), password.text);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userInfo', jsonEncode(c.userInfo.value));
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
        Container(
          width: 400,
          height: 450,
          decoration: BoxDecoration(
            color: colorController.darkMode.value ? colorController.color2() : const Color.fromARGB(255, 253, 253, 253),
            borderRadius: BorderRadius.circular(10),
            boxShadow: colorController.darkMode.value ? [] : const [
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
                          "connectLibrary".tr,
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
                    child: Obx(()=>
                      AnimatedContainer(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: mouseInButton ? colorController.color3() : colorController.color2(),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10)
                          )
                        ),
                        duration: const Duration(milliseconds: 200),
                        child: Center(
                          child: isLoading ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: colorController.color5(),
                              strokeWidth: 2,
                            ),
                          ) : Icon(
                            Icons.arrow_forward_rounded,
                            color: colorController.color5(),
                          ),
                        ),
                      ),
                    )
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}