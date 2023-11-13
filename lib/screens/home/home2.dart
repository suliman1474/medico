import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/widgets/folder.dart';

import 'home3.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});
  String get getTitle => "Home 2";

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final ScreenController screenController = Get.find();
  List<Widget> folders = [
    Folder(
      screen: Home3(),
      update: false,
      name: '1st Semester',
      downloaded: true,
    ),
    Folder(
      screen: Home3(),
      update: false,
      name: '2nd Semester',
      downloaded: true,
    ),
    Folder(
      screen: Home3(),
      update: true,
      name: '3rd Semester',
      downloaded: true,
    ),
    Folder(
      screen: Home3(),
      update: true,
      name: '4th Semester',
      downloaded: false,
    ),
    Folder(
      screen: Home3(),
      update: true,
      name: '5th Semester',
      downloaded: false,
    ),
    Folder(
      screen: Home3(),
      update: true,
      name: '6th Semester',
      downloaded: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              print('should go back to home 1');
              screenController.goBackAt(AppPage.HomeScreen);
            },
            child: Icon(
              Icons.arrow_back,
            )),
        title: Text('Home Screen 2'),
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
