import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/screens/home/profile_screen.dart';
import 'package:medico/screens/home/users_screen.dart';

import '../screens/home/about_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/news_feed_screen.dart';

enum AppPage {
  HomeScreen,
  NewsFeedScreen,
  AboutScreen,
  ProfileScreen,
}

extension AppPageExtension on AppPage {
  int get index {
    switch (this) {
      case AppPage.HomeScreen:
        return 0;
      case AppPage.NewsFeedScreen:
        return 1;
      case AppPage.AboutScreen:
        return 2;
      case AppPage.ProfileScreen:
        return 3;
      default:
        return -1;
    }
  }
}

class ScreenController extends GetxController {
  var pages = <Widget>[].obs;
  var stack = <Widget>[].obs;
  RxInt bottomNavIndex = 0.obs;
  RxInt previousIndex = 0.obs;
  DbController dbController = Get.find();
  @override
  void onInit() async {
    // Initialize your pages here, you can fetch them from your API or wherever you need.
    await assignAll();
    stack.assignAll([HomeScreen()]);
    super.onInit();
  }

  Future? assignAll() {
    pages.assignAll([
      const HomeScreen(),
      const NewsFeedScreen(),
      const AboutScreen(),
      dbController.userRole.value == UserRole.ADMIN
          ? UsersScreen()
          : ProfileScreen(),
      //const ProfileScreen(),
    ]);
    update();
    return null;
  }

  void updatePageAt(AppPage pageEnum, Widget newPage) async {
    int index = pageEnum.index;
    // int index = pages.indexWhere((page) {
    //
    //
    //
    //   if (page.key == pageEnum.index) {
    //
    //     return true;
    //   }
    //   return false;
    // });

    if (index >= 0 && index < pages.length) {
      await pushPage(pages[index]);
      pages[index] = newPage;
    }
  }

  Future pushPage(Widget page) async {
    stack.add(page);

    update();
  }

  Future popPage() async {
    stack.removeLast();

    update();
  }

  Future popWithKey() async {
    pages[bottomNavIndex.value] = stack.last;
    update();
    stack.removeLast();
  }

  void popUntil(AppPage atScreen, int remainingStack) {
    while (stack.length != remainingStack) {
      goBackAt(atScreen);
    }
  }

  void goBackAt(AppPage pageEnum) async {
    //await popPage();
    int index = pageEnum.index;
    if (stack.isNotEmpty) {
      pages[index] = stack.last;
      await popPage();
    } else {
      assignAll();
    }
  }

  bool onWillPop() {
    bottomNavIndex.value = previousIndex.value;
    update();
    return true;
  }
}
