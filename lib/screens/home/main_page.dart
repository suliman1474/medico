import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_appbar.dart';
import 'package:medico/widgets/custom_bottombar.dart';

import '../../controllers/screen_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  // var _bottomNavIndex = 0;

  ScreenController screenController = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(),
        body: Obx(() {
          return screenController.pages[screenController.bottomNavIndex.value];
        }),
        bottomNavigationBar: CustomBottomBar(
            bottomNavIndex: screenController.bottomNavIndex.value,
            onChanged: (index) {
              print('main_page onchanged function called index: ${index}');
              if (index == screenController.bottomNavIndex.value) {
                screenController.assignAll();
              } else {
                setState(() => screenController.bottomNavIndex.value = index);
              }
            }),
        // floatingActionButton: CustomFloatingButton(),
      ),
    );
  }
}
