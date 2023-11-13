import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/screens/home/about_screen.dart';
import 'package:medico/screens/home/home_screen.dart';
import 'package:medico/screens/home/news_feed_screen.dart';
import 'package:medico/screens/home/profile_screen.dart';
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
      ),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return '/home';
      case BottomBarEnum.NewFeed:
        return '/newsfeed';
      case BottomBarEnum.About:
        return '/about';
      case BottomBarEnum.Profile:
        return '/profile';
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case '/home':
        return HomeScreen();
      case '/newsfeed':
        return NewsFeedScreen();
      case '/about':
        return AboutScreen();
      case '/profile':
        return ProfileScreen();
      default:
        return DefaultWidget();
    }
  }
}
