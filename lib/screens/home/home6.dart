import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/screens/home/home4.dart';
import 'package:medico/screens/home/home5.dart';
import 'package:medico/widgets/folder.dart';

class Home6 extends StatefulWidget {
  const Home6({super.key});

  @override
  State<Home6> createState() => _Home6State();
}

class _Home6State extends State<Home6> {
  final ScreenController screenController = Get.find();
  List<Widget> folders = [
    Folder(
      screen: Home5(),
      update: true,
      name: 'Slides',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: false,
      name: 'MCQs',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: false,
      name: 'Past Papers',
      downloaded: true,
    ),
    Folder(
      screen: Home4(),
      update: true,
      name: 'Books',
      downloaded: true,
    ),
    Folder(
      screen: Home6(),
      update: true,
      name: 'Video Lectures',
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
        title: Text('Home Screen 4'),
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
