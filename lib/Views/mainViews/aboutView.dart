// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables

// import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/dialogs.dart';

class aboutView extends StatefulWidget {
  const aboutView({super.key});

  @override
  State<aboutView> createState() => _aboutViewState();
}

class _aboutViewState extends State<aboutView> {

  String version="";

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }

  void showInGit(){
    // TODO 打开GitHub仓库
  }

  void showLicense(BuildContext context){
    showLicenseDialog(context);
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  bool hoverGit=false;
  bool hoverLicense=false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon.png",
            width: 200,
          ),
          SizedBox(height: 10,),
          Text(
            "netPlayer",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5,),
          Text(
            "Next v${version}",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20,),
          // Text(
          //   "Developed by zhouc",
          // ),
          // SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => showInGit(),
                child: MouseRegion(
                  onEnter: (event) => setState(() { hoverGit=true; }),
                  onExit: (event) => setState(() { hoverGit=false; }),
                  cursor: SystemMouseCursors.click,
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: TextStyle(
                      color: hoverGit ? Colors.blue : Colors.grey[400],
                    ),
                    child: Text(
                      "在GitHub中查看",
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () => showLicense(context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) => setState(() { hoverLicense=true; }),
                  onExit: (event) => setState(() { hoverLicense=false; }),
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: TextStyle(
                      color: hoverLicense ? Colors.blue : Colors.grey[400],
                    ),
                    child: Text(
                      "关于License",
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}