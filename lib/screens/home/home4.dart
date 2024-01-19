// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:medico/controllers/screen_controller.dart';
// import 'package:medico/core/icons.dart';
// import 'package:medico/core/text_theme.dart';
// import 'package:medico/screens/home/home5.dart';
// import 'package:medico/screens/home/home6.dart';
// import 'package:medico/widgets/custom_image_view.dart';
// import 'package:medico/widgets/folder.dart';
//
// class Home4 extends StatefulWidget {
//   const Home4({super.key});
//   String get getTitle => "Home 4";
//   @override
//   State<Home4> createState() => _Home4State();
// }
//
// class _Home4State extends State<Home4> {
//   final ScreenController screenController = Get.find();
//   List<Widget> folders = [
//     Folder(
//       screen: Home5(),
//       update: true,
//       name: 'Slides',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'MCQs',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'Past Papers',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: true,
//       name: 'Books',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home6(),
//       update: true,
//       name: 'Video Lectures',
//       downloaded: true,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size(ScreenUtil().screenWidth, 50.h),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
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
//                   screenController.goBackAt(AppPage.HomeScreen);
//                 },
//                 child: Text(
//                   r'...\1st Semester\English\',
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
