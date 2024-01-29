import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/widgets/custom_file_tile.dart';
import 'package:medico/widgets/floating_button.dart';
import 'package:medico/widgets/folder.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/screen_controller.dart';
import '../../core/colors.dart';
import '../../core/text_theme.dart';
import '../../models/file_model.dart';
import '../../models/folder_model.dart';
import '../../widgets/indicator.dart';

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
//
//     super.initState();
//
//     number = widget.number;
//
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
//
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
//       //
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
  final List<FolderModel>? hiveFolders;
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
      this.hiveFolders,
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
  List<FolderModel>? hiveFolders;
  FolderModel? rootFolder;
  FolderModel? hiveRootFolder;
  late UniqueKey key;
  int? number;
  int? rootIndex;
  String? path;
  String? parentId;
  String? id;
  late bool back;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription<InternetConnectionStatus> listener;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

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
    hiveFolders = widget.hiveFolders ?? [];

    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print
            Indicator.showToast('Internet Available', Colors.green);
            print('Data connection is available.');
            if (dbController.isInternet.value == false) {
              filesController.getFolders();
            }
            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            Indicator.showToast('No Internet Connection', Colors.red);

            print('You are disconnected from the internet.');
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    print('listner cancel');
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (back == false) {
        if (filesController.folders.length > 0) {
          folders = filesController.folders
              .where((fol) => fol.parentId == '9876543210')
              .toList();
          rootFolder = filesController.folders.firstWhere(
            (fol) => fol.id == '9876543210',
          );
        }

        if (dbController.hiveFolders.length > 0) {
          hiveFolders = dbController.hiveFolders
              .where((fol) => fol.parentId == '9876543210')
              .toList();
          for (var folder in dbController.hiveFolders) {
            print('Folder ID: ${folder.id}');
          }
          hiveRootFolder = dbController.hiveFolders
              .firstWhere((fol) => fol.id == '9876543210');
        }
        // filesController.folders.forEach((fol) {
        //
        //
        // });
        // hiveRootFolder = dbController.getSubFolders(
        //     dbController.hiveFolders.value, '9876543210');

        // folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // filesController.folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // rootIndex = filesController.folders
        //     .indexWhere((fol) => fol.id == '9876543210');
      } else {
        Future.delayed(Duration(seconds: 1));
        // hiveRootFolder = dbController.getSubFolders(
        //     dbController.hiveFolders.value, parentId!);

        if (filesController.folders.length > 0) {
          FolderModel temp =
              filesController.folders.firstWhere((fol) => fol.id == id);
          print('tem.actual folders: ${temp.actualSubfolders?.length}');
          folders = temp.actualSubfolders;
          print('folders length: ${folders?.length}');

          rootFolder =
              filesController.folders.firstWhere((fol) => fol.id == id);
        }

        // for hive
        if (dbController.hiveFolders.length > 0) {
          FolderModel temp2 =
              dbController.hiveFolders.firstWhere((fol) => fol.id == id);
          print('tem2.actual folders: ${temp2.actualSubfolders?.length}');
          hiveFolders = temp2.actualSubfolders;
          print('hiveFolders length: ${hiveFolders?.length}');
          hiveRootFolder = dbController.hiveFolders
              .firstWhere((fol) => fol.id == id, orElse: null);
        }

        // folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // filesController.folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // rootIndex = filesController.folders
        //     .indexWhere((fol) => fol.id == '9876543210');
      }

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
        child: SafeArea(
          child: Scaffold(
            appBar: back
                ? AppBar(
                    leading: back
                        ? IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              screenController.popWithKey();
                            })
                        : null,
                  )
                : null,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      hiveFolders!.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: hiveFolders?.length,
                              itemBuilder: (context, index) {
                                print(
                                    'hive actual sub folders ${hiveFolders?[index].actualSubfolders?.length}');
                                return GestureDetector(
                                  onTap: () {
                                    filesController.folderPath.value =
                                        path! + '/' + hiveFolders![index].name;

                                    screenController.updatePageAt(
                                        AppPage.HomeScreen,
                                        FoldersScreen(
                                          folders: hiveFolders![index]
                                              .actualSubfolders,
                                          hiveFolders: hiveFolders![index]
                                              .actualSubfolders,
                                          id: hiveFolders![index].id,
                                          key: key,
                                          parentId: hiveFolders![index].id,
                                          path: path! +
                                              '/' +
                                              hiveFolders![index].name,
                                        ));
                                  },
                                  child: Folder(
                                    folder: hiveFolders![index],
                                    keyU: key,
                                    ifdownloaded: true,
                                  ),
                                );
                              },
                            )
                          : Container(),
                      //files
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: hiveRootFolder?.files?.length ?? 0,
                        itemBuilder: (context, index) {
                          FileModel? filez = hiveRootFolder!.files?[index];
                          return GestureDetector(
                            onTap: () async {
                              // Use http package to download the file
                              print('files clicked');
                              print('files clicked');
                              // Get the temporary directory
                              var appDocDir =
                                  await getApplicationDocumentsDirectory();

                              // Save the file to the temporary directory
                              File file = File(
                                  '${appDocDir.path}${filesController.folderPath.value}/${filez?.name}');
                              //    await file.writeAsBytes(response.bodyBytes);

                              // Open the downloaded file using OpenFile plugin
                              OpenFile.open(file.path);
                              // List<String> name = hiveRootFolder!
                              //     .files![index].name
                              //     .split('.');
                              // String? ext = name.last;
                              // if (ext == 'pdf') {
                              //   Get.to(PdfViewer(
                              //     downloadUrl: hiveRootFolder!
                              //         .files![index].downloadUrl,
                              //   ));
                              // }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomFileTile(
                                itemName: hiveRootFolder!.files![index].name,
                                onDelete: () {
                                  Get.dialog<bool>(
                                    AlertDialog(
                                      title: Text(
                                        'Delete File',
                                        style: customTexttheme.displaySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      backgroundColor: color1,
                                      content: Text(
                                        'Do you want to delete this file',
                                        style: customTexttheme.displaySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            filesController.deleteFile(
                                                filez!.name,
                                                hiveRootFolder!.id,
                                                filez.id);
                                          },
                                          child: Text(
                                            'Yes',
                                            style: customTexttheme.displaySmall
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back(); // No button
                                          },
                                          child: Text(
                                            'No',
                                            style: customTexttheme.displaySmall
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: folders?.length,
                        itemBuilder: (context, index) {
                          return hiveFolders!.any((hiveFolder) =>
                                      hiveFolder.id == folders?[index].id) ==
                                  false
                              ? GestureDetector(
                                  onTap: () {
                                    print('clicked');
                                    Get.dialog<bool>(
                                      AlertDialog(
                                        title: Text('Download Confirmation'),
                                        content: Text(
                                            'Do you want to download files from this folder?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              filesController
                                                  .downloadFilesFromFolder(
                                                      folders![index].id,
                                                      folders?[index]
                                                          .path); // Yes button
                                            },
                                            child: Text('Yes'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Get.back(); // No button
                                            },
                                            child: Text('No'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  // onTap: () {
                                  //   filesController.folderPath.value =
                                  //       path! + '/' + folders![index].name;
                                  //
                                  //   screenController.updatePageAt(
                                  //       AppPage.HomeScreen,
                                  //       FoldersScreen(
                                  //         folders: folders![index]
                                  //             .actualSubfolders,
                                  //         id: folders![index].id,
                                  //         key: key,
                                  //         parentId: folders![index].id,
                                  //         path: path! +
                                  //             '/' +
                                  //             folders![index].name,
                                  //       ));
                                  // },

                                  child: Folder(
                                    folder: folders![index],
                                    keyU: key,
                                    ifdownloaded: false,
                                  ),
                                )
                              : Container();
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
        ),
      );
    });
  }
}
