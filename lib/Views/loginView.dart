// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:netplayer_next/Views/components/loginInput.dart';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

Future<void> showDialog() async {
  final result = await FlutterPlatformAlert.showCustomAlert(
    windowTitle: '是否继续?',
    text: 'BodyTest',
    positiveButtonTitle: "继续",
    negativeButtonTitle: "取消",
    // neutralButtonTitle: "Neutral",
    options: PlatformAlertOptions(
      windows: WindowsAlertOptions(
        additionalWindowTitle: 'Window title',
        showAsLinks: true,
      ),
    ),
  );
  print(result);
}

class _loginViewState extends State<loginView> {

  TextEditingController inputURL=TextEditingController();
  TextEditingController inputUsername=TextEditingController();
  TextEditingController inputPassword=TextEditingController();

  bool mouseInButton=false;

  void loginController(){
    if(inputURL.text.isEmpty){
      
    }else if(inputUsername.text.isEmpty){

    }else if(inputPassword.text.isEmpty){

    }else{
      
    }
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
                        Icons.chevron_right_rounded,
                        size: 30,
                      ),
                      SizedBox(width: 5,),
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
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: mouseInButton ? Colors.blue[700] : Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10)
                      )
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_rounded,
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