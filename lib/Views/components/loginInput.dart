// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
// import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

class loginInputComponent extends StatefulWidget {

  final bool isPassword;
  final TextEditingController controller;
  final String inputName;

  const loginInputComponent({super.key, required this.isPassword, required this.controller, required this.inputName});

  @override
  State<loginInputComponent> createState() => _loginInputComponentState();
}

class _loginInputComponentState extends State<loginInputComponent> {
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
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              )
            ),
            obscureText: widget.isPassword,
            autocorrect: false,
            enableSuggestions: false,
          ),
        )
      ],
    );
  }
}