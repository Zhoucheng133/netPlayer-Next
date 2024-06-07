// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/loginItems.dart';
import 'package:net_player_next/variables/variables.dart';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {

  final Controller c = Get.put(Controller());

  TextEditingController username=TextEditingController();
  TextEditingController url=TextEditingController();
  TextEditingController password=TextEditingController();

  var mouseInButton=false;
  var isLoading=false;

  void loginHandler(BuildContext context){

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 450,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
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
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      Icon(
                        // FluentIcons.chevron_right_med,
                        Icons.chevron_right_rounded,
                        size: 20,
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
                        URLInput(controller: url),
                        const SizedBox(height: 20,),
                        // 用户名输入框
                        NormalInput(controller: username,),
                        const SizedBox(height: 20,),
                        // 密码输入框
                        PasswordInput(controller: password)
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
                        color: c.color4,
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