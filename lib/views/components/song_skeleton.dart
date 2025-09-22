import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SongSkeleton extends StatefulWidget {

  final bool lovedInclude; 

  const SongSkeleton({super.key, this.lovedInclude=false});

  @override
  State<SongSkeleton> createState() => _SongSkeletonState();
}

class _SongSkeletonState extends State<SongSkeleton> {
  final ColorController colorController=Get.find();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index)=>Container(
        color: colorController.darkMode.value ? colorController.color2() : Colors.white,
        height: 40,
        width: MediaQuery.of(context).size.width - 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
              child: Center(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(width: 20, height: 20)
                ),
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: MediaQuery.of(context).size.width - 700),
                child: const SkeletonLine()
              )
            ),
            const SizedBox(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 40),
                child: SkeletonLine()
              ),
            ),
            const SizedBox(
              width: 70,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Center(
                  child: SkeletonLine()
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Center(
                child: widget.lovedInclude ? const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 16,
                ) : Container(),
              ),
            ),
          ],
        ),
      )
    );
  }
}