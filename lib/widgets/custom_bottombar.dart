import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../constants/user_role.dart';

class CustomBottomBar extends StatefulWidget {
  final Function(int index)? onChanged;

  CustomBottomBar({Key? key, this.onChanged}) : super(key: key);
  // CustomBottomBar({this.onChanged});

  // Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  ScreenController screenController = Get.find();
  int selectedIndex = 0;
  DbController dbController = Get.find();
  @override
  void initState() {
    selectedIndex = screenController.bottomNavIndex.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<BottomMenuModel> bottomMenuList = [
        BottomMenuModel(
          icon: IconConstant.icHome,
          activeIcon: IconConstant.icHomeSelected,
          title: "Home",
          type: BottomBarEnum.Home,
        ),
        BottomMenuModel(
          icon: IconConstant.icNewsFeed,
          activeIcon: IconConstant.icNewsFeedSelected,
          title: "News Feed",
          type: BottomBarEnum.NewFeed,
        ),
        BottomMenuModel(
          icon: IconConstant.icAbout,
          activeIcon: IconConstant.icAboutSelected,
          title: "About",
          type: BottomBarEnum.About,
        ),
        BottomMenuModel(
          icon: IconConstant.icProfile,
          activeIcon: IconConstant.icProfileSelected,
          title: dbController.userRole.value == UserRole.ADMIN
              ? "Users"
              : "Profile",
          type: dbController.userRole.value == UserRole.ADMIN
              ? BottomBarEnum.Users
              : BottomBarEnum.Profile,
        )
      ];

      return SafeArea(
        child: Container(
          height: 100.h,
          width: 424.w,
          decoration: BoxDecoration(
            color: color1,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              fixedColor: Colors.transparent,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              currentIndex: screenController.bottomNavIndex.value,
              type: BottomNavigationBarType.fixed,
              items: List.generate(bottomMenuList.length, (index) {
                return BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      CustomImageView(
                        svgPath: bottomMenuList[index].icon,
                        height: 20.h,
                        width: 20.h,
                        margin: EdgeInsets.only(bottom: 5.h),
                        color: offwhite,
                      ),
                      Container(
                        height: 18.h,
                        child: Text(
                          bottomMenuList[index].title ?? "",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: customTexttheme.labelSmall!.copyWith(
                            color: offwhite,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                        svgPath: bottomMenuList[index].activeIcon,
                        height: 20.h,
                        width: 30.h,
                        color: white,
                        margin: EdgeInsets.only(bottom: 5.h),
                      ),
                      Container(
                        height: 18.h,
                        child: Text(
                          bottomMenuList[index].title ?? "",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: customTexttheme.labelSmall!.copyWith(
                            color: white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        height: 3.h,
                        width: 5.h,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                      )
                    ],
                  ),
                  label: '',
                );
              }),
              onTap: (index) {
                screenController.previousIndex.value =
                    screenController.bottomNavIndex.value;
                screenController.bottomNavIndex.value = index;

                widget.onChanged?.call(index);
                if (mounted) {
                  setState(() {});
                }
                ;
              },
            ),
          ),
        ),
      );
    });
  }
}

enum BottomBarEnum { Home, NewFeed, About, Profile, Users }

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });
  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
