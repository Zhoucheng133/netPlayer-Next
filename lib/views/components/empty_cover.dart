import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyCover extends StatefulWidget {
  const EmptyCover({super.key});

  @override
  State<EmptyCover> createState() => _EmptyCoverState();
}

class _EmptyCoverState extends State<EmptyCover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[800],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 取宽高中较小的一边作为基准，乘以一个比例系数
          final size = constraints.biggest.shortestSide * 0.4;
          return Center(
            child: FaIcon(
              FontAwesomeIcons.music,
              size: size,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          );
        },
      ),
    );
  }
}