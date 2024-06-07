// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NormalInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback loginHandler;
  const NormalInput({super.key, required this.controller, required this.loginHandler});

  @override
  State<NormalInput> createState() => _NormalInputState();
}

class _NormalInputState extends State<NormalInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '用户名',
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 250,
          child: TextField(
            controller: widget.controller,
            autocorrect: false,
            onEditingComplete: (){
              widget.loginHandler();
            },
            enableSuggestions: false,
            style: const TextStyle(
              fontSize: 14
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.only(top: 11, bottom: 10, left: 8, right: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class URLInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback loginHandler;
  const URLInput({super.key, required this.controller, required this.loginHandler});

  @override
  State<URLInput> createState() => _URLInputState();
}

class _URLInputState extends State<URLInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'URL地址',
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 250,
          child: TextField(
            controller: widget.controller,
            autocorrect: false,
            enableSuggestions: false,
            onEditingComplete: (){
              widget.loginHandler();
            },
            style: const TextStyle(
              fontSize: 14
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.only(top: 11, bottom: 10, left: 8, right: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback loginHandler;
  const PasswordInput({super.key, required this.controller, required this.loginHandler});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 60,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '密码',
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 250,
          child: TextField(
            controller: widget.controller,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(
              fontSize: 14
            ),
            onEditingComplete: (){
              widget.loginHandler();
            },
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.only(top: 11, bottom: 10, left: 8, right: 10),
            ),
          ),
        ),
      ],
    );
  }
}