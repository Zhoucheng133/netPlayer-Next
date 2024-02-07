// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

// import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter/material.dart';

class sideBarMenu extends StatefulWidget {
  final String menuName;
  final IconData menuIcon;
  final bool selected;
  final ValueChanged changePage;
  final dynamic id;

  const sideBarMenu({super.key, required this.menuName, required this.menuIcon, required this.selected, required this.changePage, this.id});

  @override
  State<sideBarMenu> createState() => _sideBarMenuState();
}

class _sideBarMenuState extends State<sideBarMenu> {

  bool isHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.changePage(widget.menuName);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() { isHover=true; }),
        onExit: (event) => setState(() { isHover=false; }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:widget.selected ? Color.fromARGB(255, 230, 230, 230) : isHover ? Color.fromARGB(255, 220, 220, 220) : Color.fromARGB(0, 220, 220, 220)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 10, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.menuIcon
                ),
                SizedBox(width: 8,),
                Text(
                  widget.menuName,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}