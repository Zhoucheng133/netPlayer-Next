// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:net_player_next/View/components/SideBar.dart';
import 'package:net_player_next/View/components/playBar.dart';
import 'package:net_player_next/View/mainViews/album.dart';
import 'package:net_player_next/View/mainViews/all.dart';
import 'package:net_player_next/View/mainViews/artist.dart';
import 'package:net_player_next/View/mainViews/loved.dart';
import 'package:net_player_next/View/mainViews/playList.dart';
import 'package:net_player_next/View/mainViews/search.dart';
import 'package:net_player_next/View/mainViews/settings.dart';
import 'package:net_player_next/variables/variables.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {

  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 150,
                child: sideBar(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(()=>
                      IndexedStack(
                        index: c.pageIndex.value,
                        children: const [
                          allView(),
                          lovedView(),
                          artistView(),
                          albumView(),
                          playListView(),
                          searchView(),
                          settingsView()
                        ],
                      )
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        const SizedBox(
          height: 80,
          child: playBar(),
        )
      ],
    );
  }
}