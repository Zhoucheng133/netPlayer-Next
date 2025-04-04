import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_player_next/variables/color_controller.dart';

class SettingItem extends StatefulWidget {

  final String label;
  final Widget item;
  final double? gap;
  final bool? showDivider;

  const SettingItem({super.key, required this.label, required this.item, this.gap, this.showDivider});

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 170,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Obx(()=>
                    Text(
                      widget.label,
                      style: GoogleFonts.notoSansSc(
                        color: colorController.darkMode.value ? Colors.white : Colors.black
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              SizedBox(
                width: 180,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: widget.gap??0.0),
                    child: widget.item,
                  )
                )
              ),
            ],
          ),
        ),
        widget.showDivider==false ? Container() : const SettingDivider()
      ],
    );
  }
}

class SettingDivider extends StatefulWidget {
  const SettingDivider({super.key});

  @override
  State<SettingDivider> createState() => _SettingDividerState();
}

class _SettingDividerState extends State<SettingDivider> {

  final ColorController colorController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 360,
        child: Divider(
          height: 3,
          color: colorController.color3(),
        )
      ),
    );
  }
}