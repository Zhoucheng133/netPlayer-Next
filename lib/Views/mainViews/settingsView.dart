// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/titleBar.dart';

class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {

  // 注意！无意义的参数
  TextEditingController searchInput=TextEditingController();

  void reload(){/** 空函数 */}

  void search(val){ /** 空函数 */}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          titleBox(searchController: search, title: "设置", subtitle: "", controller: searchInput, reloadList: () => reload(),),
          SizedBox(height: 10,),
          Expanded(
            // 主要的内容
            child: Container(),
          )
        ],
      ),
    );
  }
}