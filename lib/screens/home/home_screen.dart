import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/widgets/folder.dart';

import '../../controllers/screen_controller.dart';
import 'home2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  String get getTitle => "Home 1";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScreenController screenController = Get.find<ScreenController>();
  List<Widget> folders = [
    Folder(
      screen: Home2(),
      update: true,
      name: 'Bs Nursing',
      downloaded: true,
    ),
    Folder(
      screen: Home2(),
      update: false,
      name: 'KMUCAT',
      downloaded: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print('home screen called');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen 1'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return folders[index];
        },
      ),
    );
  }
}
