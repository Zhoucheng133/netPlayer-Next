// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class titleBox extends StatefulWidget {

  final ValueChanged searchController;
  final String title;
  final String subtitle;
  final TextEditingController controller;

  const titleBox({super.key, required this.searchController, required this.title, required this.subtitle, required this.controller});

  @override
  State<titleBox> createState() => _titleBoxState();
}

class _titleBoxState extends State<titleBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis
            ),
          ),
          SizedBox(width: 15,),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          Expanded(child: Container()),
          SizedBox(
            width: 200,
            child: CupertinoTextField(
              controller: widget.controller,
              style: TextStyle(
                fontSize: 14,
              ),
              suffix: GestureDetector(
                onTap: () => widget.searchController(widget.controller.text),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded),
                      SizedBox(width: 7,)
                    ],
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(8, 6, 5, 9),
              textAlignVertical: TextAlignVertical.center,
              onEditingComplete: () => widget.searchController(widget.controller.text),
            )
          )
        ],
      ),
    );
  }
}