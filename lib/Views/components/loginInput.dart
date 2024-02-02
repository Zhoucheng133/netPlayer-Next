// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

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
                  color: Colors.grey[700]
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10,),
        Container(
          width: 250,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(200, 200, 200, 200)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: TextField(
              controller: widget.controller,
              autocorrect: false,
              enableSuggestions: false,
              obscureText: widget.isPassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700]
              ),
            ),
          )
        ),
      ],
    );
  }
}