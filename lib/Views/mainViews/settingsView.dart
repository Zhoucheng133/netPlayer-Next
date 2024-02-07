// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:fluent_ui/fluent_ui.dart';

class settingsView extends StatefulWidget {
  const settingsView({super.key});

  @override
  State<settingsView> createState() => _settingsViewState();
}

class _settingsViewState extends State<settingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("设置"),
    );
  }
}