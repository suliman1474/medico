import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/pop_scope.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/widgets/custom_file_tile.dart';
import 'package:medico/widgets/floating_button.dart';
import 'package:medico/widgets/folder.dart';
import 'package:open_file/open_file.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/screen_controller.dart';
import '../../models/folder_model.dart';

// class FoldersScreen extends StatefulWidget {
//   final int? number;
//
//   const FoldersScreen({Key? key, this.number}) : super(key: key);
//
//   @override
//   State<FoldersScreen> createState() => _FoldersScreenState();
// }
//
// class _FoldersScreenState extends State<FoldersScreen> {
//   int? number;
//   ScreenController screenController = Get.find<ScreenController>();
//
//   @override
//   void initState() {
//     print('init calledc');
//     super.initState();
//
//     number = widget.number;
//     print('number: $number');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         leading: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.arrow_back_ios_rounded),
//         ),
//       ),
//       body: Center(
//         child: TextButton(
//           onPressed: () {
//             print('folder clicked');
//             //  Get.toNamed('/folder-screen', arguments: number! + 1);
//             // Get.to(() => FoldersScreen(),
//             //     arguments: number! + 1, preventDuplicates: false);
//             // Get.to(() => FoldersScreen(s
//             //       number: number! + 1,
//             //     ));
//             screenController.updatePageAt(
//                 AppPage.HomeScreen,
//                 FoldersScreen(
//                   number: number! + 1,
//                   key: UniqueKey(),
//                 ));
//           },
//           child: Text(
//             'Number: $number',
//             style: TextStyle(fontSize: 24),
//           ),
//         ),
//       ),
//     );
//     return Scaffold(
//       // appBar: CustomAppBar(),
//       body: Container(),
//       // bottomNavigationBar: CustomBottomBar(onChanged: (index) {
//       //   print('main_page onchanged function called index: ${index}');
//       //   if (index == screenController.bottomNavIndex.value) {
//       //     screenController.assignAll();
//       //   } else {
//       //     setState(() {
//       //       screenController.previousIndex.value =
//       //           screenController.bottomNavIndex.value;
//       //       screenController.bottomNavIndex.value = index;
//       //     });
//       //   }
//       // }),
//     );
//   }
// }

class FoldersScreen extends StatefulWidget {
  final List<FolderModel>? folders;
  final int? number;
  final String? parentId;
  bool back;
  String path;
  String? id;
  FoldersScreen(
      {super.key,
      this.folders,
      this.number,
      this.back = true,
      this.parentId,
      required this.path,
      this.id});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  ScreenController screenController = Get.find<ScreenController>();
  AuthenticationController authController = Get.find();
  DbController dbController = Get.find();
  FilesController filesController = Get.find();
  List<FolderModel>? folders;
  FolderModel? rootFolder;
  late UniqueKey key;
  int? number;
  int? rootIndex;
  String? path;
  String? parentId;
  String? id;
  late bool back;
  void loadUser() async {
    await dbController.loadUserRole();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   filesController.getFolders();
    // });
    folders = widget.folders ?? [];
    number = widget.number;
    key = UniqueKey();
    back = widget.back;
    path = widget.path;
    filesController.folderPath.value = path!;
    parentId = widget.parentId ?? '9876543210';
    id = widget.id;

    print('path: $path');
    // print('number: ${number.toString()}');
    // print('37');
    // loadUser();
  }

  void showProgressDialog() {
    if (filesController.uploading.value &&
        filesController.uploadProgress.value > 0.0) {
      Get.dialog(
        AlertDialog(
          title: Text('Uploading'),
          content: Obx(() {
            return Column(
              children: [
                LinearProgressIndicator(
                  value: filesController.uploadProgress.value / 100,
                ),
                SizedBox(height: 10),
                Text(
                  '${filesController.uploadProgress.value.toInt()}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          }),
        ),
      );
    }
  }

  Widget _buildProgressCard(double progress) {
    return Container();
    // return Center(
    //   child: Container(
    //     width: (Get.width / 2) + 50.w,
    //     //   decoration: BoxDecoration(backgroundBlendMode: BlendMode.darken),
    //     color: Colors.red,
    //     child: Card(
    //       elevation: 8.0,
    //       color: color1,
    //       //// Adjust the shadow as needed
    //       margin: const EdgeInsets.all(16.0),
    //       child: Container(
    //         padding: const EdgeInsets.all(16.0),
    //         width: Get.width / 2 + 30.w,
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             SizedBox(
    //                 height: 20.h,
    //                 child: LinearProgressIndicator(
    //                   value: progress,
    //                   backgroundColor: Colors.white,
    //                   color: color2,
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 )),
    //             SizedBox(height: 10.h),
    //             Text(
    //               '${(progress * 100).toInt()}%',
    //               style: customTexttheme.displaySmall
    //                   ?.copyWith(color: Colors.white),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (filesController.folders.length > 0) {
        print('back: $back');
        if (back == false) {
          print('back is false : ${filesController.folders.length}');
          folders = filesController.folders
              .where((fol) => fol.parentId == '9876543210')
              .toList();
          // filesController.folders.forEach((fol) {
          //   print('Folder ID: ${fol.id}, Parent ID: ${fol.parentId}');
          //   print('files length: ${fol.files?.length}');
          // });
          rootFolder = filesController.folders
              .firstWhere((fol) => fol.id == '9876543210');
          rootIndex = filesController.folders
              .indexWhere((fol) => fol.id == '9876543210');
          print('folderrs length: ${folders?.length}');
          print('files length: ${rootFolder?.files!.length}');
        } else {
          print('=====changes obbserved');
          Future.delayed(Duration(seconds: 1));
          FolderModel temp =
              filesController.folders.firstWhere((fol) => fol.id == id);
          folders = temp.actualSubfolders;
          rootFolder =
              filesController.folders.firstWhere((fol) => fol.id == id);
          rootIndex = filesController.folders
              .indexWhere((fol) => fol.id == '9876543210');
          print('files length: ${rootFolder?.files!.length}');
        }
      }
      print('first conditon: ${rootFolder?.files?.length == 0}');
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (back == false) {
            // Ask for exiting app dialog
            await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Exit App?'),
                content: Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      filesController.folders.clear();
                      SystemNavigator.pop();
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
          } else {
            // Call another function
            await screenController.popWithKey();
            ;
          }
        },
        child: Scaffold(
          appBar: back
              ? AppBar(
                  leading: back
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            print('pop out');
                            screenController.popWithKey();
                          })
                      : null,
                )
              : null,
          body: (folders == null || folders!.length == 0) &&
                  rootFolder?.files?.length == 0
              ? rootFolder?.files?.length == 0 &&
                      filesController.uploading.value == false
                  ? Container(
                      child: Center(
                        child: Text('empty'),
                      ),
                    )
                  : filesController.uploading.value &&
                          filesController.uploadProgress.value == 0.0
                      ? _buildProgressCard(0.0)
                      : filesController.uploadProgress.value > 0.0
                          ? _buildProgressCard(
                              filesController.uploadProgress.value / 100)
                          : Container(
                              child: Center(
                                child: Text('empty 2'),
                              ),
                            )
              : Stack(
                  children: [
                    // if (filesController.uploading.value &&
                    //     filesController.uploadProgress.value == 0.0)
                    // Show initial card
                    filesController.uploading.value == false &&
                            filesController.uploadProgress.value == 0.0
                        ? _buildProgressCard(0.0)
                        : Container(),

                    // Show progress card
                    filesController.uploadProgress.value > 0.0
                        ? _buildProgressCard(
                            filesController.uploadProgress.value / 100)
                        : Container(),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: folders?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  filesController.folderPath.value =
                                      path! + '/' + folders![index].name;
                                  print(
                                      'folder path in gesture detector: ${filesController.folderPath.value}');
                                  print(
                                      'list of actual sub folders: ${folders![index].actualSubfolders?.length}');
                                  screenController.updatePageAt(
                                      AppPage.HomeScreen,
                                      FoldersScreen(
                                        folders:
                                            folders![index].actualSubfolders,
                                        id: folders![index].id,
                                        key: key,
                                        parentId: folders![index].id,
                                        path:
                                            path! + '/' + folders![index].name,
                                      ));
                                },
                                child: Folder(
                                  folder: folders![index],
                                  keyU: key,
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rootFolder?.files?.length ?? 0,
                            itemBuilder: (context, index) {
                              print(
                                  'downloadUrl: ${rootFolder!.files![index].downloadUrl}');
                              return GestureDetector(
                                onTap: () {
                                  OpenFile.open("/sdcard/example.txt");
                                  // Get.to(PdfViewer(
                                  //   downloadUrl:
                                  //       rootFolder!.files![index].downloadUrl,
                                  // ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // child: Container(
                                  //   height:
                                  //       300, // Set a fixed height or adjust it according to your layout
                                  //   child: ,
                                  // ),

                                  child: CustomFileTile(
                                    itemName: rootFolder!.files![index].name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
          floatingActionButton: dbController.userRole.value == UserRole.ADMIN
              ? CustomFloatingButton(
                  parentId: parentId,
                )
              : null,
        ),
      );
    });
  }
}
