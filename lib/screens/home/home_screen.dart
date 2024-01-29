import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/screens/home/folders_screen.dart';
import 'package:medico/widgets/floating_button.dart';
import 'package:medico/widgets/folder.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/screen_controller.dart';
import '../../models/folder_model.dart';
import 'home2.dart';

class HomeScreen extends StatefulWidget {
  final List<FolderModel>? folders;
  const HomeScreen({super.key, this.folders});
  String get getTitle => "Home 1";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScreenController screenController = Get.find<ScreenController>();
  AuthenticationController authController = Get.find();
  DbController dbController = Get.find();
  FilesController filesController = Get.find();
  // List<Widget> folders = [
  //   Folder(
  //     screen: Home2(),
  //     update: true,
  //     name: 'Bs Nursing',
  //     downloaded: true,
  //   ),
  //   Folder(
  //     screen: Home2(),
  //     update: false,
  //     name: 'KMUCAT',
  //     downloaded: true,
  //   ),
  // ];

  void loadUser() async {
    await dbController.loadUserRole();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Your code here will run after the current frame has been drawn
      //  filesController.folders.clear();
      loadUser();
      // List<FolderModel> folders = await filesController.getFolders();
      // List<FolderModel> rootFolders = folders
      //     .where((fol) => fol.parentId == null || fol.parentId!.isEmpty)
      //     .toList();
      //
      // Get.to(
      //     () => FoldersScreen(
      //           number: 1,
      //         ),
      //     arguments: 1,
      //     preventDuplicates: false);
      // Get.toNamed('/folder-screen', arguments: 1);

      screenController.updatePageAt(
          AppPage.HomeScreen,
          FoldersScreen(
            // folders: rootFolders,
            back: false,

            path: '/folders',
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
