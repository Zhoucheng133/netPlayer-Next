import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/variables/color_controller.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ArtistSkeleton extends StatefulWidget {
  const ArtistSkeleton({super.key});

  @override
  State<ArtistSkeleton> createState() => _ArtistSkeletonState();
}

class _ArtistSkeletonState extends State<ArtistSkeleton> {

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index)=>Container(
        color: colorController.darkMode.value ? colorController.color2() : Colors.white,
        height: 40,
        width: MediaQuery.of(context).size.width - 200,
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Center(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(width: 20, height: 20)
                ),
              )
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                    width: 180,
                  ),
                )
              )
            ),
            SizedBox(
              width: 100,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SkeletonLine(),
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}