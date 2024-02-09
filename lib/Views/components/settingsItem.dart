// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class switchItem extends StatefulWidget {
  
  final bool value;
  final String text;
  final ValueChanged setValue;

  const switchItem({super.key, required this.value, required this.text, required this.setValue});

  @override
  State<switchItem> createState() => _switchItemState();
}

class _switchItemState extends State<switchItem> {

  Color getSwitchColor(Set<MaterialState> states){
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.text,
          textAlign: TextAlign.left,
        ),
        SizedBox(width: 5,),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            hoverColor: Colors.white,
            thumbColor: MaterialStateProperty.resolveWith(getSwitchColor),
            splashRadius: 0,
            onChanged: (bool value) { 
              widget.setValue(value);
            }, 
            value: widget.value,
          ),
        )
      ],
    );
  }
}