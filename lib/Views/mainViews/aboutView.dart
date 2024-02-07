// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:fluent_ui/fluent_ui.dart';

class aboutView extends StatefulWidget {
  const aboutView({super.key});

  @override
  State<aboutView> createState() => _aboutViewState();
}

class _aboutViewState extends State<aboutView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("关于"),
    );
  }
}