import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/core/text_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    print('home screen called');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen 1'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            print('should go to another page');
            screenController.updatePageAt(AppPage.HomeScreen, Home2());
          },
          child: Container(
            child: Text(
              'Go to another page Home 2:',
              style: customTexttheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
