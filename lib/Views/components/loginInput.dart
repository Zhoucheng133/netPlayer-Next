// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../paras/paras.dart';
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/cupertino.dart';

class loginInputComponent extends StatefulWidget {

  final bool isPassword;
  final TextEditingController controller;
  final String inputName;
  final VoidCallback loginController;

  const loginInputComponent({super.key, required this.isPassword, required this.controller, required this.inputName, required this.loginController});

  @override
  State<loginInputComponent> createState() => _loginInputComponentState();
}

class _loginInputComponentState extends State<loginInputComponent> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.inputName,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10,),
        SizedBox(
          width: 250,
          child: TextField(
            contextMenuBuilder: (_,__)=>Container(),
            controller: widget.controller,
            style: TextStyle(
              fontSize: 14
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(8, 10, 8, 11),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: c.primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5)
              )
            ),
            onSubmitted: (_) => widget.loginController(),
            obscureText: widget.isPassword,
            autocorrect: false,
            enableSuggestions: false,
          ),
        )
      ],
    );
  }
}