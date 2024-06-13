// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/variables.dart';

class viewHeader extends StatefulWidget {

  final String title;
  final String subTitle;
  final String page;
  final dynamic id;
  const viewHeader({super.key, required this.title, required this.subTitle, required this.page, this.id});

  @override
  State<viewHeader> createState() => _viewHeaderState();
}

class _viewHeaderState extends State<viewHeader> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: c.color5,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  widget.subTitle,
                  style: TextStyle(
                    color: c.color5,
                    fontSize: 13
                  ),
                ),
              ],
            ),
          ),
          Obx(()=>
            Icon(
              Icons.my_location_rounded,
              size: 17,
              color: c.nowPlay['playFrom']==widget.page ? c.color6 : Colors.grey[300],
            )
          )
        ],
      ),
    );
  }
}