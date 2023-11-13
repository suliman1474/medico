import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/widgets/folder.dart';

import 'home4.dart';

class Home3 extends StatefulWidget {
  const Home3({super.key});
  String get getTitle => "Home 3";

  @override
  State<Home3> createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  final ScreenController screenController = Get.find();
  List<Widget> folders = [
    Folder(
      screen: Home4(),
      update: false,
      name: 'Fundamentals of Nursing',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: false,
      name: 'Anatomy & Physiology',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: false,
      name: 'Microbiology',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: true,
      name: 'Bio Chemistry',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: true,
      name: 'English',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: true,
      name: 'Computer Science',
      downloaded: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              screenController.goBackAt(AppPage.HomeScreen);
            },
            child: Icon(
              Icons.arrow_back,
            )),
        title: Text('Home Screen 3'),
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
