// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

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
      title: "Profile",
      type: BottomBarEnum.Profile,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 93.h,
        width: 424.w,
        decoration: BoxDecoration(
          color: color1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: List.generate(bottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: Column(
                children: [
                  CustomImageView(
                    svgPath: bottomMenuList[index].icon,
                    height: 20.h,
                    width: 20.h,
                    margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    color: offwhite,
                  ),
                  Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: customTexttheme.labelSmall,
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
                    width: 20.h,
                    color: white,
                    margin: const EdgeInsets.only(bottom: 5).h,
                  ),
                  Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: customTexttheme.labelSmall!.copyWith(color: white),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5).h,
                    height: 3.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10).w,
                    ),
                  )
                ],
              ),
              label: '',
            );
          }),
          onTap: (index) {
            selectedIndex = index;
            widget.onChanged?.call(bottomMenuList[index].type);
            setState(() {});
          },
        ),
      ),
    );
  }
}

enum BottomBarEnum { Home, NewFeed, About, Profile }

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
