// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

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
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Color.fromARGB(255, 240, 240, 240),
      child: Center(
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
        ),  
      ),
    );
  }
}