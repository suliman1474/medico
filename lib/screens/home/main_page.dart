import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_appbar.dart';
import 'package:medico/widgets/custom_bottombar.dart';
import 'package:medico/widgets/floating_button.dart';

import '../../controllers/screen_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  var _bottomNavIndex = 0;

  ScreenController screenController = Get.find<ScreenController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(),
        body: Obx(() {
          return screenController.pages[_bottomNavIndex];
        }),
        bottomNavigationBar: CustomBottomBar(
            bottomNavIndex: _bottomNavIndex,
            onChanged: (index) {
              print('main_page onchanged function called index: ${index}');
              if (index == _bottomNavIndex) {
                screenController.assignAll();
              } else {
                setState(() => _bottomNavIndex = index);
              }
            }),
        floatingActionButton: CustomFloatingButton(),
      ),
    );
  }
}
