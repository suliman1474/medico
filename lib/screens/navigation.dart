import 'package:flutter/material.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/screens/about.dart';
import 'package:medico/screens/home.dart';
import 'package:medico/screens/news_feed.dart';
import 'package:medico/screens/profile.dart';
import 'package:medico/widgets/custom_appbar.dart';
import 'package:medico/widgets/custom_bottombar.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(),
        body: Navigator(
          key: navigatorKey,
          initialRoute: '/home',
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, ani, ani1) => getCurrentPage(routeSetting.name!),
            transitionDuration: Duration(milliseconds: 600),
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (BottomBarEnum type) {
            Navigator.pushNamed(
              navigatorKey.currentContext!,
              getCurrentRoute(type),
            );
          },
        ),
      ),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return '/home';
      case BottomBarEnum.NewFeed:
        return '/newsfeed';
      case BottomBarEnum.About:
        return '/about';
      case BottomBarEnum.Profile:
        return '/profile';
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case '/home':
        return HomeScreen();
      case '/newsfeed':
        return NewsFeedScreen();
      case '/about':
        return AboutScreen();
      case '/profile':
        return ProfileScreen();
      default:
        return DefaultWidget();
    }
  }
}
