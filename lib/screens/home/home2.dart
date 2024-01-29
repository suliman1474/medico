// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:medico/controllers/screen_controller.dart';
// import 'package:medico/core/app_export.dart';
// import 'package:medico/core/text_theme.dart';
// import 'package:medico/widgets/custom_image_view.dart';
// import 'package:medico/widgets/folder.dart';
//
// import 'home3.dart';
//
// class Home2 extends StatefulWidget {
//   const Home2({super.key});
//   String get getTitle => "Home 2";
//
//   @override
//   State<Home2> createState() => _Home2State();
// }
//
// class _Home2State extends State<Home2> {
//   final ScreenController screenController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> folders = [
//       Folder(
//         screen: Home3(),
//         update: true,
//         name: '1st Semester',
//         downloaded: true,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '2nd Semester',
//         downloaded: true,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '3rd Semester',
//         downloaded: true,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '4th Semester',
//         downloaded: true,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '5th Semester',
//         downloaded: true,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '6th Semester',
//         downloaded: false,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '7th Semester',
//         downloaded: false,
//       ),
//       Folder(
//         screen: Home3(),
//         update: false,
//         name: '8th Semester',
//         downloaded: false,
//       ),
//     ];
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size(ScreenUtil().screenWidth, 50.h),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//
//                   screenController.goBackAt(AppPage.HomeScreen);
//                 },
//                 child: CustomImageView(
//                   svgPath: IconConstant.icBack,
//                   height: 30.h,
//                   width: 30.w,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//
//                   screenController.goBackAt(AppPage.HomeScreen);
//                 },
//                 child: Text(
//                   r'Bs Nursing\',
//                   style: customTexttheme.displayLarge,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: folders.length,
//         itemBuilder: (context, index) {
//           return folders[index];
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home 2'),
    );
  }
}
