// ignore_for_file: camel_case_types, file_names, prefer_const_constructors

import 'package:fluent_ui/fluent_ui.dart';

class artistsView extends StatefulWidget {
  const artistsView({super.key});

  @override
  State<artistsView> createState() => _artistsViewState();
}

class _artistsViewState extends State<artistsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("艺人"),
    );
  }
}