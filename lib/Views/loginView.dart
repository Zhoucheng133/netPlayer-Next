// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

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
    return  Center(
      child: TextButton(
        onPressed: (){
          showDialog();
        }, 
        child: Text("测试按钮")
      ),  
    );
  }
}