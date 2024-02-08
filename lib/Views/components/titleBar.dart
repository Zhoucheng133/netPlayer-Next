// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class titleBox extends StatefulWidget {

  final ValueChanged searchController;
  final String title;
  final String subtitle;
  final TextEditingController controller;
  final VoidCallback reloadList;

  const titleBox({super.key, required this.searchController, required this.title, required this.subtitle, required this.controller, required this.reloadList});

  @override
  State<titleBox> createState() => _titleBoxState();
}

class _titleBoxState extends State<titleBox> {

  bool hoverLocate=false;
  bool hoverReload=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromARGB(255, 203, 255, 144),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
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
              ],
            )
          ),
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverLocate=true; }),
              onExit: (event) => setState(() { hoverLocate=false; }),
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 200),
                tween: ColorTween(begin: Colors.grey[800], end: hoverLocate ? Colors.blue : Colors.grey[800]),
                builder: (_, value, __){
                  return Icon(
                    Icons.my_location_rounded,
                    size: 20,
                    color: value,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10,),
          Stack(
            children: [
              SizedBox(
                width: 200,
                child: Center(
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 25, 11),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 210, 210, 210),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    onEditingComplete: () => widget.searchController(widget.controller.text),
                  ),
                )
              ),
              Positioned(
                child: SizedBox(
                  width: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () => widget.searchController(widget.controller.text),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(width: 5,)
                    ],
                  )
                )
              ),
            ],
          ),
          SizedBox(width: 20,),
          GestureDetector(
            onTap: () => widget.reloadList(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) => setState(() { hoverReload=true; }),
              onExit: (event) => setState(() { hoverReload=false; }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: hoverReload ? Colors.blue[700] : Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}