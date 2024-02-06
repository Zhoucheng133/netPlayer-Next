// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

// import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:net_player_next/functions/request.dart';

import '../paras/paras.dart';
import 'components/loginInput.dart';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {

  final Controller c = Get.put(Controller());

  TextEditingController inputURL=TextEditingController();
  TextEditingController inputUsername=TextEditingController();
  TextEditingController inputPassword=TextEditingController();

  bool mouseInButton=false;

  bool isLoading=false;

  Future<void> systemAlert(String title, String content) async {
    showDialog(
      context: context, 
      builder: (context) => ContentDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FilledButton(
            child: Text("好的"),
            onPressed: () => Navigator.pop(context)
          )
        ],
      ),
    );
  }

  bool isURL(String url){
    if(url.startsWith("http://") || url.startsWith("https://")){
      return true;
    }else{
      return false;
    }
  }

  Future<void> loginController() async {
    if(isLoading==true){
      return;
    }
    setState(() {
      isLoading=true;
    });
    if(inputURL.text.isEmpty){
      systemAlert("无法登录", "没有输入音乐服务器的URL地址");
    }else if(!isURL(inputURL.text)){
      systemAlert("无法登录", "音乐服务器的URL地址不合法");
    }else if(inputUsername.text.isEmpty){
      systemAlert("无法登录", "没有输入音乐服务器的用户名");
    }else if(inputPassword.text.isEmpty){
      systemAlert("无法登录", "没有输入音乐服务器的密码");
    }else{
      var resp = await loginRequest(inputURL.text, inputUsername.text, inputPassword.text);
      // print(resp);
      if(resp['status']=="failed"){
        systemAlert("无法登录", "用户名或密码不正确");
      }else if(resp['status']=="URL Err"){
        systemAlert("无法登录", "URL地址错误");
      }else if(resp['status']=="ok"){
        try {
          Map<String, String> userInfo={
            'url': resp['url'],
            'username': resp['username'],
            'salt': resp['salt'],
            'token': resp['token'],
          };
          // print(userInfo);
          c.updateUserInfo(userInfo);
          print(c.userInfo.value);
        } catch (e) {
          print(e);
          systemAlert("无法登录", "请求用户信息失败");
        }
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        width: 500,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
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
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      Icon(
                        FluentIcons.chevron_right_med,
                        size: 15,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "连接到你的音乐库",
                        style: TextStyle(
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
                        loginInputComponent(isPassword: false, controller: inputURL, inputName: 'URL地址',),
                        SizedBox(height: 20,),
                        // 用户名输入框
                        loginInputComponent(isPassword: false, controller: inputUsername, inputName: '用户名',),
                        SizedBox(height: 20,),
                        // 密码输入框
                        loginInputComponent(isPassword: true, controller: inputPassword, inputName: '密码',),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: (){
                  loginController();
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
                      color: mouseInButton ? Colors.blue.darker : Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10)
                      )
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Center(
                      child: Icon(
                        FluentIcons.chrome_back_mirrored,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            )
          ] 
        ),
      ),  
    );
  }
}