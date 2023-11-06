// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../screens/main_page.dart';
//
// class ScreenController extends GetxController {
//   var pages = <Widget>[].obs;
//   var stack = <Widget>[].obs;
//   @override
//   void onInit() async {
//     // Initialize your pages here, you can fetch them from your API or wherever you need.
//     await assignAll();
//     stack.assignAll([const MainPage()]);
//     super.onInit();
//   }
//
//   Future? assignAll() {
//     pages.assignAll([
//       const MainPage(),
//       const MainPage(),
//       const MainPage(),
//       const MainPage(),
//     ]);
//     update();
//     return null;
//   }
//
//   void updatePageAtIndex(int index, Widget newPage) async {
//     if (index >= 0 && index < pages.length) {
//       await pushPage(pages[index]);
//       pages[index] = newPage;
//     }
//   }
//
//   Future pushPage(Widget page) async {
//     stack.add(page);
//     print('page added to stack');
//     update();
//   }
//
//   Future popPage() async {
//     print('poping stack last');
//     stack.removeLast();
//     update();
//   }
//
//   void popUntil(int atScreen, int remainingStack) {
//     while (stack.length != remainingStack) {
//       print('loop of popUntil');
//       updateStack(atScreen);
//     }
//   }
//
//   void updateStack(index) async {
//     //await popPage();
//     if (stack.isNotEmpty) {
//       print('stack not empty');
//       pages[index] = stack.last;
//       await popPage();
//     } else {
//       print('stack is empty');
//       assignAll();
//     }
//   }
// }
