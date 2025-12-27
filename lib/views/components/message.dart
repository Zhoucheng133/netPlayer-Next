import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void showMessage(bool isSuccess, String text, BuildContext context){
  showFlash(
    duration: const Duration(milliseconds: 1500),
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200), 
    builder: (context, controller) => FlashBar(
      behavior: FlashBehavior.floating,
      position: FlashPosition.top,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      iconColor: Colors.white,
      margin: EdgeInsets.only(
        top: 30,
        left: (MediaQuery.of(context).size.width-280)/2,
        right: (MediaQuery.of(context).size.width-280)/2
      ),
      icon: const Icon(
        Icons.info_outline_rounded,
        color: Colors.white,
        size: 20,
      ),
      controller: controller, 
      content: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    context: context
  );
}