import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/screen_controller.dart';

import 'home3.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});
  String get getTitle => "Home 2";

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  final ScreenController screenController = Get.find();

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
      body: Container(
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    print('should=to home 2');
                    screenController.updatePageAt(AppPage.HomeScreen, Home3());
                  },
                  child: Text(
                    'Go to Home 3',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
