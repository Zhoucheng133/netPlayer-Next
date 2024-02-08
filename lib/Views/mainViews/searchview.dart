// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/titleBar.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {

  // 注意!不在titleBox中使用
  TextEditingController searchInput=TextEditingController();

  void reload(){/** 空函数 */}

  void search(val){ /** 空函数 */}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,30,20,20),
      child: Column(
        children: [
          // TODO 注意传递副标题
          titleBox(searchController: search, title: "搜索", subtitle: "", controller: searchInput, reloadList: () => reload(),),
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