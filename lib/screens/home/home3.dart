// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:medico/controllers/screen_controller.dart';
// import 'package:medico/core/app_export.dart';
// import 'package:medico/core/text_theme.dart';
// import 'package:medico/widgets/custom_image_view.dart';
// import 'package:medico/widgets/folder.dart';
//
// import 'home4.dart';
//
// class Home3 extends StatefulWidget {
//   const Home3({super.key});
//   String get getTitle => "Home 3";
//
//   @override
//   State<Home3> createState() => _Home3State();
// }
//
// class _Home3State extends State<Home3> {
//   final ScreenController screenController = Get.find();
//   List<Widget> folders = [
//     Folder(
//       screen: Home4(),
//       update: true,
//       name: 'Fundamentals of Nursing',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'Anatomy & Physiology',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'Microbiology',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'Biochemistry',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'English',
//       downloaded: true,
//     ),
//     Folder(
//       screen: Home4(),
//       update: false,
//       name: 'Computer Science',
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
//                   r'Bs Nursing\1st Semester\',
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
