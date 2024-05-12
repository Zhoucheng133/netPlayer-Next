// ignore_for_file: file_names, camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';

class switchItem extends StatefulWidget {
  
  final bool value;
  final String text;
  final ValueChanged setValue;
  final dynamic showTip;

  final dynamic enableSwitch;

  const switchItem({super.key, required this.value, required this.text, required this.setValue, this.enableSwitch, this.showTip});

  @override
  State<switchItem> createState() => _switchItemState();
}

class _switchItemState extends State<switchItem> {

  Color getSwitchColor(Set<MaterialState> states){
    return Colors.white;
  }

  void showTip(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('快捷键提示'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('播放/暂停: Ctrl + Alt + 空格'),
              Text('上一首: Ctrl + Alt + 左箭头'),
              Text('下一首: Ctrl + Alt + 右箭头')
            ],
          ),
          actions: <Widget>[
            FilledButton(
              onPressed: () async {
                // 点击确定之后的操作
                Navigator.pop(context);
              }, 
              child: Text("好的")
            ),
          ],
        );
      },
    );
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
          ),
          widget.showTip!=null ? IconButton(
            onPressed: ()=>showTip(), 
            icon: Icon(Icons.lightbulb_rounded),
            iconSize: 18,
          ): Container()
        ],
      ),
    );
  }
}