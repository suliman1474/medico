// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:medico/controllers/db_controller.dart';
// import 'package:medico/controllers/files_controller.dart';
// import 'package:medico/widgets/custom_file_tile.dart';
// import 'package:medico/widgets/floating_button.dart';
// import 'package:medico/widgets/folder.dart';
// import 'package:medico/widgets/pdfViewer.dart';
// import 'package:open_file_plus/open_file_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// import '../../constants/user_role.dart';
// import '../../controllers/auth_controller.dart';
// import '../../controllers/screen_controller.dart';
// import '../../core/colors.dart';
// import '../../core/text_theme.dart';
// import '../../models/folder_model.dart';
// import '../../widgets/custom_appbar.dart';
// import '../../widgets/custom_bottombar.dart';
// import 'home2.dart';
//
// // class FoldersEgScreen extends StatefulWidget {
// //   final int? number;
// //
// //   const FoldersEgScreen({Key? key, this.number}) : super(key: key);
// //
// //   @override
// //   State<FoldersEgScreen> createState() => _FoldersEgScreenState();
// // }
// //
// // class _FoldersEgScreenState extends State<FoldersEgScreen> {
// //   int? number;
// //   ScreenController screenController = Get.find<ScreenController>();
// //
// //   @override
// //   void initState() {
// //
// //     super.initState();
// //
// //     number = widget.number;
// //
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: true,
// //         leading: IconButton(
// //           onPressed: () {},
// //           icon: Icon(Icons.arrow_back_ios_rounded),
// //         ),
// //       ),
// //       body: Center(
// //         child: TextButton(
// //           onPressed: () {
// //
// //             //  Get.toNamed('/folder-screen', arguments: number! + 1);
// //             // Get.to(() => FoldersEgScreen(),
// //             //     arguments: number! + 1, preventDuplicates: false);
// //             // Get.to(() => FoldersEgScreen(s
// //             //       number: number! + 1,
// //             //     ));
// //             screenController.updatePageAt(
// //                 AppPage.HomeScreen,
// //                 FoldersEgScreen(
// //                   number: number! + 1,
// //                   key: UniqueKey(),
// //                 ));
// //           },
// //           child: Text(
// //             'Number: $number',
// //             style: TextStyle(fontSize: 24),
// //           ),
// //         ),
// //       ),
// //     );
// //     return Scaffold(
// //       // appBar: CustomAppBar(),
// //       body: Container(),
// //       // bottomNavigationBar: CustomBottomBar(onChanged: (index) {
// //       //
// //       //   if (index == screenController.bottomNavIndex.value) {
// //       //     screenController.assignAll();
// //       //   } else {
// //       //     setState(() {
// //       //       screenController.previousIndex.value =
// //       //           screenController.bottomNavIndex.value;
// //       //       screenController.bottomNavIndex.value = index;
// //       //     });
// //       //   }
// //       // }),
// //     );
// //   }
// // }
//
// class FoldersEgScreen extends StatefulWidget {
//   final List<FolderModel>? folders;
//   final int? number;
//   final String? parentId;
//   bool back;
//   String path;
//   String? id;
//   FoldersEgScreen(
//       {super.key,
//       this.folders,
//       this.number,
//       this.back = true,
//       this.parentId,
//       required this.path,
//       this.id});
//
//   @override
//   State<FoldersEgScreen> createState() => _FoldersEgScreenState();
// }
//
// class _FoldersEgScreenState extends State<FoldersEgScreen> {
//   ScreenController screenController = Get.find<ScreenController>();
//   AuthenticationController authController = Get.find();
//   DbController dbController = Get.find();
//   FilesController filesController = Get.find();
//   List<FolderModel>? folders;
//   FolderModel? rootFolder;
//   late UniqueKey key;
//   int? number;
//   int? rootIndex;
//   String? path;
//   String? parentId;
//   String? id;
//   late bool back;
//   void loadUser() async {
//     await dbController.loadUserRole();
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//     //   filesController.getFolders();
//     // });
//     folders = widget.folders ?? [];
//     number = widget.number;
//     key = UniqueKey();
//     back = widget.back;
//     path = widget.path;
//     filesController.folderPath.value = path!;
//     parentId = widget.parentId ?? '9876543210';
//     id = widget.id;
//
//     // print('number: ${number.toString()}');
//     //
//     // loadUser();
//   }
//
//   void showProgressDialog() {
//     if (filesController.uploading.value &&
//         filesController.uploadProgress.value > 0.0) {
//       Get.dialog(
//         AlertDialog(
//           title: Text('Uploading'),
//           content: Obx(() {
//             return Column(
//               children: [
//                 LinearProgressIndicator(
//                   value: filesController.uploadProgress.value / 100,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   '${filesController.uploadProgress.value.toInt()}%',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             );
//           }),
//         ),
//       );
//     }
//   }
//
//   Widget _buildProgressCard(double progress) {
//     return Container();
//     // return Center(
//     //   child: Container(
//     //     width: (Get.width / 2) + 50.w,
//     //     //   decoration: BoxDecoration(backgroundBlendMode: BlendMode.darken),
//     //     color: Colors.red,
//     //     child: Card(
//     //       elevation: 8.0,
//     //       color: color1,
//     //       //// Adjust the shadow as needed
//     //       margin: const EdgeInsets.all(16.0),
//     //       child: Container(
//     //         padding: const EdgeInsets.all(16.0),
//     //         width: Get.width / 2 + 30.w,
//     //         child: Column(
//     //           mainAxisSize: MainAxisSize.min,
//     //           children: [
//     //             SizedBox(
//     //                 height: 20.h,
//     //                 child: LinearProgressIndicator(
//     //                   value: progress,
//     //                   backgroundColor: Colors.white,
//     //                   color: color2,
//     //                   borderRadius: BorderRadius.circular(10.0),
//     //                 )),
//     //             SizedBox(height: 10.h),
//     //             Text(
//     //               '${(progress * 100).toInt()}%',
//     //               style: customTexttheme.displaySmall
//     //                   ?.copyWith(color: Colors.white),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (filesController.folders.length > 0) {
//         if (back == false) {
//           folders = filesController.folders
//               .where((fol) => fol.parentId == '9876543210')
//               .toList();
//           // filesController.folders.forEach((fol) {
//           //
//           //
//           // });
//           rootFolder = filesController.folders
//               .firstWhere((fol) => fol.id == '9876543210');
//           rootIndex = filesController.folders
//               .indexWhere((fol) => fol.id == '9876543210');
//         } else {
//           Future.delayed(Duration(seconds: 1));
//           FolderModel temp =
//               filesController.folders.firstWhere((fol) => fol.id == id);
//           folders = temp.actualSubfolders;
//           rootFolder =
//               filesController.folders.firstWhere((fol) => fol.id == id);
//           rootIndex = filesController.folders
//               .indexWhere((fol) => fol.id == '9876543210');
//         }
//       }
//
//       return PopScope(
//         canPop: false,
//         onPopInvoked: (didPop) async {
//           if (back == false) {
//             // Ask for exiting app dialog
//             await showDialog<bool>(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: Text('Exit App?'),
//                 content: Text('Are you sure you want to exit the app?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Get.back(),
//                     child: Text('No'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       filesController.folders.clear();
//                       SystemNavigator.pop();
//                     },
//                     child: Text('Yes'),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             // Call another function
//             await screenController.popWithKey();
//             ;
//           }
//         },
//         child: Scaffold(
//           appBar: back
//               ? AppBar(
//                   leading: back
//                       ? IconButton(
//                           icon: Icon(Icons.arrow_back),
//                           onPressed: () {
//                             screenController.popWithKey();
//                           })
//                       : null,
//                 )
//               : null,
//           body: (folders == null || folders!.length == 0) &&
//                   rootFolder?.files?.length == 0
//               ? rootFolder?.files?.length == 0 &&
//                       filesController.uploading.value == false
//                   ? Container(
//                       child: Center(
//                         child: Text('empty'),
//                       ),
//                     )
//                   : filesController.uploading.value &&
//                           filesController.uploadProgress.value == 0.0
//                       ? _buildProgressCard(0.0)
//                       : filesController.uploadProgress.value > 0.0
//                           ? _buildProgressCard(
//                               filesController.uploadProgress.value / 100)
//                           : Container(
//                               child: Center(
//                                 child: Text('empty 2'),
//                               ),
//                             )
//               : Stack(
//                   children: [
//                     // if (filesController.uploading.value &&
//                     //     filesController.uploadProgress.value == 0.0)
//                     // Show initial card
//                     filesController.uploading.value == false &&
//                             filesController.uploadProgress.value == 0.0
//                         ? _buildProgressCard(0.0)
//                         : Container(),
//
//                     // Show progress card
//                     filesController.uploadProgress.value > 0.0
//                         ? _buildProgressCard(
//                             filesController.uploadProgress.value / 100)
//                         : Container(),
//                     SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: folders?.length,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 onTap: () {
//                                   filesController.folderPath.value =
//                                       path! + '/' + folders![index].name;
//
//                                   screenController.updatePageAt(
//                                       AppPage.HomeScreen,
//                                       FoldersEgScreen(
//                                         folders:
//                                             folders![index].actualSubfolders,
//                                         id: folders![index].id,
//                                         key: key,
//                                         parentId: folders![index].id,
//                                         path:
//                                             path! + '/' + folders![index].name,
//                                       ));
//                                 },
//                                 child: Folder(
//                                   folder: folders![index],
//                                   keyU: key,
//                                 ),
//                               );
//                             },
//                           ),
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: NeverScrollableScrollPhysics(),
//                             itemCount: rootFolder?.files?.length ?? 0,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 onTap: () async {
//                                   // Use http package to download the file
//                                   // var response = await http.get(Uri.parse(
//                                   //     rootFolder!.files![index].downloadUrl));
//                                   //
//                                   // // Get the temporary directory
//                                   // var tempDir = await getTemporaryDirectory();
//                                   //
//                                   // // Save the file to the temporary directory
//                                   // File file =
//                                   //     File('${tempDir.path}/downloaded_file');
//                                   // await file.writeAsBytes(response.bodyBytes);
//                                   //
//                                   // // Open the downloaded file using OpenFile plugin
//                                   // OpenFile.open(file.path);
//                                   List<String> name =
//                                       rootFolder!.files![index].name.split('.');
//                                   String? ext = name.last;
//                                   if (ext == 'pdf') {
//                                     Get.to(PdfViewer(
//                                       downloadUrl:
//                                           rootFolder!.files![index].downloadUrl,
//                                     ));
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   // child: Container(
//                                   //   height:
//                                   //       300, // Set a fixed height or adjust it according to your layout
//                                   //   child: ,
//                                   // ),
//
//                                   child: CustomFileTile(
//                                     itemName: rootFolder!.files![index].name,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//           floatingActionButton: dbController.userRole.value == UserRole.ADMIN
//               ? CustomFloatingButton(
//                   parentId: parentId,
//                 )
//               : null,
//         ),
//       );
//     });
//   }
// }
