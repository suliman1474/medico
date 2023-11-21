import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/widgets/folder.dart';

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
    List<Widget> folders = [
      Folder(
        screen: Home2(),
        update: true,
        name: 'Bs Nursing',
        downloaded: true,
      ),
      Folder(
        screen: Home2(),
        update: false,
        name: 'KMUCAT',
        downloaded: true,
      ),
    ];
    print('home screen called');
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: ListView.builder(
          itemCount: folders.length,
          itemBuilder: (context, index) {
            return folders[index];
          },
        ),
      ),
      // floatingActionButton: CustomFloatingButton(),
    );
  }
}
