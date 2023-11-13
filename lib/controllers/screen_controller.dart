import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medico/screens/home/profile_screen.dart';

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
      const ProfileScreen(),
      //const ProfileScreen(),
    ]);
    update();
    return null;
  }

  void updatePageAt(AppPage pageEnum, Widget newPage) async {
    int index = pageEnum.index;
    // int index = pages.indexWhere((page) {
    //   print('index pageenum name: ${pageEnum}');
    //   print('index page key : ${page.key}');
    //   print('index where pageEnum: ${AppPage}');
    //   if (page.key == pageEnum.index) {
    //     print('where page meeets');
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
}
