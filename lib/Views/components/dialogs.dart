// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';

Future<void> showLicenseDialog(BuildContext context) async {
  await showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text("版权信息"),
      content: Text("版权信息balabala"),
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