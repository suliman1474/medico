import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/screens/home/home5.dart';
import 'package:medico/screens/home/home6.dart';
import 'package:medico/widgets/folder.dart';

class Home4 extends StatefulWidget {
  const Home4({super.key});
  String get getTitle => "Home 4";
  @override
  State<Home4> createState() => _Home4State();
}

class _Home4State extends State<Home4> {
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
// Obx(() {
              //   return ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: screenController.stack.length,
              //     itemBuilder: (context, index) {
              //       Widget currentWidget = screenController.stack[index];
              //       //   String title = currentWidget.title; // Replace this with the actual title of your widgets
              //
              //       // Use the ListTile widget to display the title and arrow icon
              //       return ListTile(
              //         title: Text(title),
              //         trailing: Icon(Icons.arrow_forward),
              //         onTap: () {
              //           // Handle tap on the widget (if needed)
              //         },
              //       );
              //     },
              //   );
              // }),