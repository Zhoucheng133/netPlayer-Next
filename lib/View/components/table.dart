// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';


class songHeader extends StatefulWidget {
  const songHeader({super.key});

  @override
  State<songHeader> createState() => _songHeaderState();
}

class _songHeaderState extends State<songHeader> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width - 200,
          child: const Row(
            children: [
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('序号'),
                )
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('标题'),
                )
              ),
              SizedBox(
                width: 70,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.timer_outlined,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.menu_rounded,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 2,
          width: MediaQuery.of(context).size.width - 200,
          decoration: BoxDecoration(
            color: c.color4,
            borderRadius: BorderRadius.circular(2)
          ),
        )
      ],
    );
  }
}