import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/widgets/floating_button.dart';
import 'package:medico/widgets/folder.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
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
  AuthenticationController authController = Get.find();
  DbController dbController = Get.find();

  void loadUser() async {
    await dbController.loadUserRole();
  }

  @override
  void initState() {
    // TODO: implement initState
    loadUser();
    print(dbController.userRole.value);
    super.initState();
  }

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
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          actions: [
            // Add the IconButton with the logout icon
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Call the signOut function when the button is pressed
                await authController.logout();

                // Navigate to the login or home screen after signing out
                // You may replace '/login' with the appropriate route
                Get.offNamed('/login');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return folders[index];
              },
            ),
          ],
        ),
        floatingActionButton: dbController.userRole.value == UserRole.ADMIN
            ? CustomFloatingButton()
            : null,
      );
    });
  }
}
