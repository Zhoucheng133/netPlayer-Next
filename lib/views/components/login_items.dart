import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';

class UserNameInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback loginHandler;
  const UserNameInput({super.key, required this.controller, required this.loginHandler});

  @override
  State<UserNameInput> createState() => _UserNameInputState();
}

class _UserNameInputState extends State<UserNameInput> {

  var onFocus=FocusNode();
  final ColorController colorController=Get.find();
  bool isFocus=false;

  @override
  void initState() {
    super.initState();
    onFocus.addListener(onFocusChange);
  }

  void onFocusChange(){
    if(onFocus.hasFocus){
      setState(() {
        isFocus=true;
      });
    }else{
      setState(() {
        isFocus=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      AnimatedContainer(
        width: 280,
        decoration: BoxDecoration(
          color: colorController.darkMode.value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isFocus ? Colors.grey.withAlpha(2) : Colors.grey.withAlpha(0),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ]
        ),
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "username".tr,
                style: GoogleFonts.notoSansSc(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      focusNode: onFocus,
                      controller: widget.controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                      ),
                      onEditingComplete: () => widget.loginHandler(),
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        )
      ),
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

  var onFocus=FocusNode();
  bool isFocus=false;
  final ColorController colorController=Get.find();

  @override
  void initState() {
    super.initState();
    onFocus.addListener(onFocusChange);
  }

  void onFocusChange(){
    if(onFocus.hasFocus){
      setState(() {
        isFocus=true;
      });
    }else{
      setState(() {
        isFocus=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      AnimatedContainer(
        width: 280,
        decoration: BoxDecoration(
          color: colorController.darkMode.value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isFocus ? Colors.grey.withAlpha(2) : Colors.grey.withAlpha(0),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ]
        ),
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "serverURL".tr,
                style: GoogleFonts.notoSansSc(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.public,
                    size: 18,
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      focusNode: onFocus,
                      controller: widget.controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'http(s)://',
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                        hintStyle: GoogleFonts.notoSansSc(
                          color: Colors.grey[400]
                        )
                      ),
                      onEditingComplete: () => widget.loginHandler(),
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        )
      ),
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

  var onFocus=FocusNode();
  bool isFocus=false;
  final ColorController colorController=Get.find();

  @override
  void initState() {
    super.initState();
    onFocus.addListener(onFocusChange);
  }

  void onFocusChange(){
    if(onFocus.hasFocus){
      setState(() {
        isFocus=true;
      });
    }else{
      setState(() {
        isFocus=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      AnimatedContainer(
        width: 280,
        decoration: BoxDecoration(
          color: colorController.darkMode.value ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isFocus ? Colors.grey.withAlpha(2) : Colors.grey.withAlpha(0),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ]
        ),
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "password".tr,
                style: GoogleFonts.notoSansSc(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.key_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: TextField(
                      focusNode: onFocus,
                      controller: widget.controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                      ),
                      obscureText: true,
                      onEditingComplete: () => widget.loginHandler(),
                      autocorrect: false,
                      enableSuggestions: false,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                    )
                  )
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}