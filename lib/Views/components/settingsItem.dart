// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class switchItem extends StatefulWidget {
  
  final bool value;
  final String text;
  final ValueChanged setValue;

  final dynamic enableSwitch;

  const switchItem({super.key, required this.value, required this.text, required this.setValue, this.enableSwitch});

  @override
  State<switchItem> createState() => _switchItemState();
}

class _switchItemState extends State<switchItem> {

  Color getSwitchColor(Set<MaterialState> states){
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Expanded(child: Container()),
                Text(
                  widget.text,
                ),
              ],
            ),
          ),
          SizedBox(width: 5,),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              hoverColor: Colors.white,
              thumbColor: MaterialStateProperty.resolveWith(getSwitchColor),
              splashRadius: 0,
              onChanged: widget.enableSwitch==false ? null : (bool value) { 
                widget.setValue(value);
              }, 
              value: widget.value,
            ),
          )
        ],
      ),
    );
  }
}