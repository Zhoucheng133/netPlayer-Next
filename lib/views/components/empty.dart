import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';

class Empty extends StatefulWidget {
  const Empty({super.key});

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 10,
        children: [
          const FaIcon(FontAwesomeIcons.boxOpen),
          Text('empty'.tr),
        ],
      ),
    );
  }
}

class NoPlaylist extends StatefulWidget {
  const NoPlaylist({super.key});

  @override
  State<NoPlaylist> createState() => _NoPlaylistState();
}

class _NoPlaylistState extends State<NoPlaylist> {

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 10,
        children: [
          FaIcon(
            FontAwesomeIcons.boxOpen,
            size: 16,
            color: colorController.color5(),
          ), 
          Text(
            'noplaylist'.tr,
            style: TextStyle(
              fontSize: 13,
              color: colorController.color5(),
            ),
          ),
        ],
      ),
    );
  }
}