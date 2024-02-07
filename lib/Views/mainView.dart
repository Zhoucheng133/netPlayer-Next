// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:fluent_ui/fluent_ui.dart';

import 'components/sideBar.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: sideBar(),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}