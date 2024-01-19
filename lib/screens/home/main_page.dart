import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/files_controller.dart';
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
  FilesController filesController = Get.find();
  @override
  Widget build(BuildContext context) {
    // final appLifecycleState = WidgetsBinding.instance.lifecycleState;
    // if (appLifecycleState == AppLifecycleState.resumed) {
    //   // App resumed from background
    //   print('app resumed');
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     filesController.getFolders();
    //   });
    // } else {
    //   // App started fresh or in a different state
    // }
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(),
        body: Obx(() {
          print(
              'screen at navidex : ${screenController.pages[screenController.bottomNavIndex.value]}');
          return screenController.pages[screenController.bottomNavIndex.value];
        }),
        bottomNavigationBar: CustomBottomBar(onChanged: (index) {
          print('main_page onchanged function called index: ${index}');
          if (index == screenController.bottomNavIndex.value) {
            screenController.assignAll();
          } else {
            setState(() {
              screenController.previousIndex.value =
                  screenController.bottomNavIndex.value;
              screenController.bottomNavIndex.value = index;
            });
          }
        }),
        // floatingActionButton: CustomFloatingButton(),
      ),
    );
  }
}
