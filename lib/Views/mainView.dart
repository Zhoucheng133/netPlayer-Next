// ignore_for_file: camel_case_types, file_names

import 'package:fluent_ui/fluent_ui.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Main!"),
    );
  }
}