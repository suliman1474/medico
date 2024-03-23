import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/widgets/custom_file_tile.dart';
import 'package:medico/widgets/floating_button.dart';
import 'package:medico/widgets/folder.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/screen_controller.dart';
import '../../core/colors.dart';
import '../../core/text_theme.dart';
import '../../models/file_model.dart';
import '../../models/folder_model.dart';
import '../../widgets/custom_link_tile.dart';
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
  RxBool isInternet = false.obs;
  void loadUser() async {
    await dbController.loadUserRole();
  }

  void downloadFolder(int index) async {
    ;
    Get.dialog<bool>(
      AlertDialog(
        title: Text('Download Confirmation'),
        backgroundColor: color1,
        content: Text('Do you want to download files from this folder?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              filesController.downloadFilesFromFolder(
                  folders![index].id, folders?[index].path); // Yes button
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
  }

  void checkNet() async {
    isInternet.value = await InternetConnectionChecker().hasConnection;
    ;
  }

  ScrollController _scrollController = ScrollController();
  String pathFolder = '';
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
    if (widget.back) {
      pathFolder = filesController.folderPath.value;
      pathFolder = pathFolder.replaceFirst('/folders/', '');
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }

    // checkNet();
    // listener = InternetConnectionChecker().onStatusChange.listen(
    //   (InternetConnectionStatus status) {
    //     switch (status) {
    //       case InternetConnectionStatus.connected:
    //         // ignore: avoid_print
    //         Indicator.showToast('Internet Available', Colors.green);
    //         ;
    //         isInternet.value = true;
    //         if (dbController.isInternet.value == false) {
    //           filesController.getFolders();
    //         }
    //         break;
    //       case InternetConnectionStatus.disconnected:
    //         // ignore: avoid_print
    //         Indicator.showToast('No Internet Connection', Colors.red);
    //         isInternet.value = false;
    //         ;
    //         break;
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ;
      void navigate(int index) {
        filesController.folderPath.value = path! + '/' + folders![index].name;

        screenController.updatePageAt(
            AppPage.HomeScreen,
            FoldersScreen(
              folders: folders![index].actualSubfolders,
              id: folders![index].id,
              key: key,
              parentId: folders![index].id,
              path: path! + '/' + folders![index].name,
            ));
      }

      if (back == false) {
        if (filesController.folders.length > 0) {
          // FolderModel temp = filesController.folders
          //     .firstWhere((fol) => fol.id == '9876543210');
          // ;
          // folders = temp.actualSubfolders;
          folders = filesController.folders
              .where((fol) => fol.parentId == '9876543210')
              .toList();
          for (FolderModel folder in folders!) {
            ;
          }
          rootFolder = filesController.folders.firstWhere(
            (fol) => fol.id == '9876543210',
          );
          print('folder.links .length: ${rootFolder?.links?.length}');
        }

        if (dbController.hiveFolders.length > 0) {
          hiveFolders = dbController.hiveFolders
              .where((fol) => fol.parentId == '9876543210')
              .toList();

          hiveRootFolder = dbController.hiveFolders
              .firstWhere((fol) => fol.id == '9876543210');
        }
        ;
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   setState(() {});
        // });
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

          folders = temp.actualSubfolders;

          rootFolder =
              filesController.folders.firstWhere((fol) => fol.id == id);
          print('folder.links .length: when back ${rootFolder?.links?.length}');
        }

        // for hive
        if (dbController.hiveFolders.length > 0 &&
            dbController.userRole.value == UserRole.USER) {
          FolderModel temp2 =
              dbController.hiveFolders.firstWhere((fol) => fol.id == id);

          hiveFolders = temp2.actualSubfolders;

          hiveRootFolder = dbController.hiveFolders
              .firstWhere((fol) => fol.id == id, orElse: null);
        }
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   setState(() {});
        // });
        // folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // filesController.folders?.removeWhere((folder) =>
        //     hiveFolders?.any((hiveFolder) => hiveFolder.id == folder.id) ??
        //     false);
        // rootIndex = filesController.folders
        //     .indexWhere((fol) => fol.id == '9876543210');
      }
      print('role: ${dbController.userRole.value}');
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
        child: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (back == false) {
              ;
            } else {
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
                              screenController.popWithKey();
                            })
                        : null,
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: [
                          Text(
                            pathFolder,
                            maxLines: 1,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            body: RefreshIndicator(
              color: color2,
              onRefresh: () async {
                if (await InternetConnectionChecker().hasConnection) {
                  filesController.getFolders();
                } else {
                  Indicator.showToast('No Internet Connection', Colors.red);
                }
                // return filesController.getFolders();
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        //offline folders
                        if (dbController.userRole.value == UserRole.USER)
                          hiveFolders!.length > 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: hiveFolders?.length,
                                    itemBuilder: (context, index) {
                                      int indexH =
                                          dbController.hiveFolders!.indexWhere(
                                        (element) =>
                                            element.id ==
                                            hiveFolders?[index].id,
                                      );
                                      bool? updatable;

                                      print('indexH: ${indexH}');
                                      if (indexH != -1) {
                                        int? indexInFolders = filesController
                                            .folders
                                            .indexWhere((folder) =>
                                                folder.id ==
                                                dbController
                                                    .hiveFolders?[indexH].id);
                                        if (indexInFolders != -1) {
                                          updatable = dbController
                                                  .hiveFolders?[indexH]
                                                  .files
                                                  ?.length !=
                                              filesController
                                                  .folders?[indexInFolders!]
                                                  .files
                                                  ?.length;
                                          ;
                                        }
                                      }
                                      ;
                                      return GestureDetector(
                                        onTap: () {
                                          filesController.folderPath.value =
                                              path! +
                                                  '/' +
                                                  hiveFolders![index].name;

                                          screenController.updatePageAt(
                                              AppPage.HomeScreen,
                                              FoldersScreen(
                                                folders: hiveFolders![index]
                                                    .actualSubfolders,
                                                hiveFolders: hiveFolders![index]
                                                    .actualSubfolders,
                                                id: hiveFolders![index].id,
                                                key: key,
                                                parentId:
                                                    hiveFolders![index].id,
                                                path: path! +
                                                    '/' +
                                                    hiveFolders![index].name,
                                              ));
                                        },
                                        child: Folder(
                                          folder: hiveFolders![index],
                                          keyU: key,
                                          ifdownloaded: true,
                                          updatable: updatable ?? false,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                        // offline files

                        if (dbController.userRole.value == UserRole.USER)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: hiveRootFolder?.files?.length ?? 0,
                            itemBuilder: (context, index) {
                              FileModel? filez = hiveRootFolder!.files?[index];
                              return GestureDetector(
                                onTap: () async {
                                  if (dbController.userRole.value ==
                                      UserRole.ADMIN) {
                                    var response = await http.get(Uri.parse(
                                        rootFolder!.files![index].downloadUrl));

                                    // Get the temporary directory
                                    var tempDir = await getTemporaryDirectory();

                                    // Save the file to the temporary directory
                                    File file = File(
                                        '${tempDir.path}/${rootFolder!.files![index].name}');
                                    await file.writeAsBytes(response.bodyBytes);

                                    // Open the downloaded file using OpenFile plugin
                                    OpenFile.open(file.path);
                                  } else {
                                    // Use http package to download the file
                                    print('open file for user');
                                    // Get the temporary directory
                                    var appDocDir =
                                        await getApplicationDocumentsDirectory();

                                    // Save the file to the temporary directory
                                    File file = File(
                                        '${appDocDir.path}${filesController.folderPath.value}/${filez?.name}');
                                    //    await file.writeAsBytes(response.bodyBytes);
                                    // /data/user/0/com.example.medico/app_flutter/folders/Bs Nursing/Semester 1st/books//my_video_.mp4
                                    print(
                                        'file for user tot open exsit: ${File('${appDocDir.path}${filesController.folderPath.value}/${filez?.name}').existsSync()}');
                                    // Open the downloaded file using OpenFile plugin
                                    OpenFile.open(file.path);
                                  }
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 5.h),
                                  child: CustomFileTile(
                                    itemName:
                                        hiveRootFolder!.files![index].name,
                                    isLocked: hiveRootFolder!.isLocked,
                                    downloadable: false,
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
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // No button
                                              },
                                              child: Text(
                                                'No',
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onShare: () async {
                                      Indicator.showLoading();
                                      var appDocDir =
                                          await getApplicationDocumentsDirectory();

                                      // Create a file for the downloaded file
                                      // File file = File(
                                      String filePath =
                                          '${appDocDir.path}${filesController.folderPath.value}/${filez?.name}';
                                      try {
                                        print(
                                            'file exist ${File(filePath).existsSync()}');
                                        final result = await Share.shareXFiles(
                                          [XFile(filePath)],
                                        );
                                        print('999afa95');

                                        if (result.status ==
                                            ShareResultStatus.success) {
                                          print(
                                              'Thank you for sharing the picture!');
                                        } else {
                                          print('failed');
                                        }
                                        Indicator.closeLoading();
                                      } catch (error) {
                                        Indicator.closeLoading();

                                        print('Error sharing file: $error');
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        //=======online folders for user

                        if (dbController.userRole.value == UserRole.USER)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: folders?.length,
                            itemBuilder: (context, index) {
                              return hiveFolders!.any((hiveFolder) =>
                                          hiveFolder.id ==
                                          folders?[index].id) ==
                                      false
                                  ? GestureDetector(
                                      onTap: () {
                                        if (dbController.userRole ==
                                            UserRole.USER) {
                                          downloadFolder(index);
                                        } else {
                                          navigate(index);
                                        }
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
                        //online folders for admin
                        if (dbController.userRole.value == UserRole.ADMIN)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: folders == null ? 0 : folders?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (dbController.userRole == UserRole.USER) {
                                    downloadFolder(index);
                                  } else {
                                    navigate(index);
                                  }
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
                                  key: UniqueKey(),
                                  folder: folders![index],
                                  keyU: UniqueKey(),
                                  ifdownloaded: false,
                                ),
                              );
                            },
                          ),
                        //=======updatable files

                        if (dbController.userRole.value == UserRole.USER)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rootFolder?.files?.length ?? 0,
                            itemBuilder: (context, index) {
                              ;
                              return hiveRootFolder?.files!.any((hiveFile) =>
                                          hiveFile.id ==
                                          rootFolder?.files?[index].id) ==
                                      false
                                  ? GestureDetector(
                                      onTap: () async {
                                        print('upfatable download click');
                                        if (dbController.userRole.value ==
                                            UserRole.ADMIN) {
                                          // Use http package to download the file
                                          var response = await http.get(
                                              Uri.parse(rootFolder!
                                                  .files![index].downloadUrl));

                                          // Get the temporary directory
                                          var tempDir =
                                              await getTemporaryDirectory();

                                          // Save the file to the temporary directory
                                          File file = File(
                                              '${tempDir.path}/downloaded_file');
                                          await file
                                              .writeAsBytes(response.bodyBytes);

                                          // Open the downloaded file using OpenFile plugin
                                          OpenFile.open(file.path);
                                        } else {
                                          //download file

                                          Get.dialog<bool>(
                                            AlertDialog(
                                              title: Text(
                                                  'Download Confirmation',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              backgroundColor: color1,
                                              content: Text(
                                                'Do you want to download this file?',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    filesController
                                                        .downloadSingleFile(
                                                            rootFolder!.id,
                                                            rootFolder!.path,
                                                            rootFolder!
                                                                .files![index]
                                                                .name,
                                                            rootFolder!
                                                                .files![index]
                                                                .id);
                                                    // Yes button
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
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.h, bottom: 5.h),
                                        // child: Container(
                                        //   height:
                                        //       300, // Set a fixed height or adjust it according to your layout
                                        //   child: ,
                                        // ),

                                        child: CustomFileTile(
                                          itemName:
                                              rootFolder!.files![index].name,
                                          isLocked: rootFolder!.isLocked,
                                          downloadable: true,
                                          onDownload: () async {
                                            print('on downlaod clicked');
                                            Get.dialog<bool>(
                                              AlertDialog(
                                                title: Text(
                                                  'Download Confirmation',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: color1,
                                                content: Text(
                                                  'Do you want to download this file?',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      filesController
                                                          .downloadSingleFile(
                                                              rootFolder!.id,
                                                              rootFolder!.path,
                                                              rootFolder!
                                                                  .files![index]
                                                                  .name,
                                                              rootFolder!
                                                                  .files![index]
                                                                  .id);
                                                      // Yes button
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
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        // admin files

                        if (dbController.userRole.value == UserRole.ADMIN)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rootFolder?.files?.length ?? 0,
                            itemBuilder: (context, index) {
                              ;
                              return GestureDetector(
                                onTap: () async {
                                  if (dbController.userRole.value ==
                                      UserRole.ADMIN) {
                                    // Use http package to download the file
                                    var response = await http.get(Uri.parse(
                                        rootFolder!.files![index].downloadUrl));

                                    // Get the temporary directory
                                    var tempDir = await getTemporaryDirectory();

                                    // Save the file to the temporary directory
                                    File file = File(
                                        '${tempDir.path}/${rootFolder!.files![index].name}');
                                    await file.writeAsBytes(response.bodyBytes);

                                    // Open the downloaded file using OpenFile plugin
                                    OpenFile.open(file.path);
                                  } else {}
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 5.h),
                                  // child: Container(
                                  //   height:
                                  //       300, // Set a fixed height or adjust it according to your layout
                                  //   child: ,
                                  // ),

                                  child: CustomFileTile(
                                    itemName: rootFolder!.files![index].name,
                                    isLocked: rootFolder!.isLocked,

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
                                                filesController.deleteFileAdmin(
                                                    rootFolder!.id,
                                                    rootFolder!
                                                        .files![index].id,
                                                    rootFolder!
                                                        .files![index].path);
                                              },
                                              child: Text(
                                                'Yes',
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // No button
                                              },
                                              child: Text(
                                                'No',
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onRename: () async {
                                      TextEditingController controller =
                                          TextEditingController();
                                      String fileNameWithoutExtension =
                                          rootFolder!.files![index].name
                                              .split('/')
                                              .last
                                              .split('.')
                                              .first;
                                      controller.text =
                                          fileNameWithoutExtension; // Default value in dialog

                                      await Get.defaultDialog<String>(
                                        title: 'Rename File',
                                        content: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            labelText: 'New File Name',
                                            // Display the extension as suffix text
                                            suffixText: '.' +
                                                rootFolder!.files![index].name
                                                    .split('.')
                                                    .last,
                                          ),
                                        ),
                                        textConfirm: 'OK',
                                        textCancel: 'Cancel',
                                        confirmTextColor: Colors.white,
                                        buttonColor: color1,
                                        onConfirm: () async {
                                          Get.back();
                                          await filesController.renameFileAdmin(
                                            rootFolder!.id,
                                            rootFolder!.files![index].id,
                                            controller.text +
                                                '.' +
                                                rootFolder!.files![index].name
                                                    .split('.')
                                                    .last,
                                          );
                                        },
                                      );
                                    },
                                    onShare: () async {
                                      Indicator.showLoading();
                                      var response = await http.get(Uri.parse(
                                          rootFolder!
                                              .files![index].downloadUrl));

                                      // Get the temporary directory
                                      var tempDir =
                                          await getTemporaryDirectory();

                                      // Save the file to the temporary directory
                                      File file = File(
                                          '${tempDir.path}/${rootFolder!.files![index].name}');
                                      await file
                                          .writeAsBytes(response.bodyBytes);

                                      // Create a file for the downloaded file

                                      try {
                                        //s  final XFile file = XFile(filePath);

                                        final result = await Share.shareXFiles(
                                          [XFile(file.path)],
                                        );
                                        print('999afa95');

                                        if (result.status ==
                                            ShareResultStatus.success) {
                                          print(
                                              'Thank you for sharing the picture!');
                                        } else {
                                          print('failed');
                                        }
                                        // await Share.shareXFiles(
                                        //   [file],
                                        // );
                                        Indicator.closeLoading();
                                      } catch (error) {
                                        print('Error sharing file: $error');
                                        Indicator.closeLoading();
                                        Get.snackbar(
                                          'Error',
                                          error.toString() ?? '',
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    // onRename: () {
                                    //   print('on rename clicked');
                                    //   TextEditingController controller =
                                    //       TextEditingController();
                                    //   controller.text = rootFolder!
                                    //       .files![index].name
                                    //       .split('/')
                                    //       .last; // Default value in dialog
                                    //
                                    //   Get.defaultDialog<String>(
                                    //     title: 'Rename File',
                                    //     content: TextField(
                                    //       controller: controller,
                                    //       decoration: InputDecoration(
                                    //           labelText: 'New File Name'),
                                    //     ),
                                    //     textConfirm: 'OK',
                                    //     textCancel: 'Cancel',
                                    //     confirmTextColor: Colors.white,
                                    //     buttonColor: color1,
                                    //     onConfirm: () async {
                                    //       print(
                                    //           'Controller.text: ${controller.text}');
                                    //       Get.back();
                                    //       await filesController.renameFileAdmin(
                                    //           rootFolder!.id,
                                    //           rootFolder!.files![index].id,
                                    //           controller.text);
                                    //
                                    //       // Get.back(result: controller.text);
                                    //     },
                                    //   );
                                    // },
                                  ),
                                ),
                              );
                            },
                          ),

                        //links for user online

                        if (dbController.userRole.value == UserRole.ADMIN)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rootFolder?.links?.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  filesController.goToYoutube(
                                      rootFolder!.links![index].url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 5.h),
                                  child: CustomLinkTile(
                                    itemName: rootFolder!.links![index].name,
                                    onDelete: () {
                                      Get.dialog<bool>(
                                        AlertDialog(
                                          title: Text(
                                            'Delete Link',
                                            style: customTexttheme.displaySmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          backgroundColor: color1,
                                          content: Text(
                                            'Do you want to delete this link',
                                            style: customTexttheme.displaySmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.back();
                                                print('ON DELETED CLICKED');
                                                await filesController
                                                    .deleteLink(
                                                        rootFolder!.id,
                                                        rootFolder!
                                                            .links![index].id);
                                              },
                                              child: Text(
                                                'Yes',
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back(); // No button
                                              },
                                              child: Text(
                                                'No',
                                                style: customTexttheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onRename: () async {
                                      Map<String, String>? result =
                                          await _showEditDialog(
                                              rootFolder!.links![index].name,
                                              rootFolder!.links![index].url);

                                      await filesController.editLink(
                                          rootFolder!.id,
                                          rootFolder!.links![index].id,
                                          result!['name']!,
                                          result['url']!);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),

                        if (dbController.userRole.value == UserRole.USER)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: rootFolder?.links?.length ?? 0,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  print('pressed');
                                  filesController.goToYoutube(
                                      rootFolder!.links![index].url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 5.h, bottom: 5.h),
                                  child: CustomLinkTile(
                                    itemName: rootFolder!.links![index].name,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    )
                  ]))
                ],
              ),
            ),
            floatingActionButton: dbController.userRole.value == UserRole.ADMIN
                ? Align(
                    alignment: Alignment(-0.8, 1.0),
                    child: CustomFloatingButton(
                      parentId: parentId,
                    ),
                  )
                : null,
          ),
        ),
      );
    });
  }
}

Future<Map<String, String>?> _showEditDialog(
    String oldFileName, String oldUrl) async {
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  nameController.text = oldFileName; // Default value in dialog
  urlController.text = oldUrl; // Default value in dialog

  return Get.defaultDialog<Map<String, String>>(
    title: 'Edit Link',
    content: Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'New Link Name',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: urlController,
          decoration: InputDecoration(
            labelText: 'New Link URL',
          ),
        ),
      ],
    ),
    textConfirm: 'OK',
    textCancel: 'Cancel',
    confirmTextColor: Colors.white,
    buttonColor: Colors.blue, // Change to your desired button color
    onConfirm: () {
      print('Name: ${nameController.text}, URL: ${urlController.text}');
      Get.back(
        result: {
          'name': nameController.text,
          'url': urlController.text,
        },
      );
    },
  );
}
