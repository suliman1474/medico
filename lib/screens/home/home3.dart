import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';

import 'home4.dart';

class Home3 extends StatefulWidget {
  const Home3({super.key});
  String get getTitle => "Home 3";

  @override
  State<Home3> createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  final ScreenController screenController = Get.find();

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
      body: Container(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    print('should=to home 2');
                    screenController.updatePageAt(AppPage.HomeScreen, Home4());
                  },
                  child: Text(
                    'Go to Home 4',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
