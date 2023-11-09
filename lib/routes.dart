// import 'package:medico/screens/onboarding/splash.dart';

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:medico/screens/about.dart';
import 'package:medico/screens/home.dart';
import 'package:medico/screens/navigation.dart';
import 'package:medico/screens/news_feed.dart';
import 'package:medico/screens/profile.dart';

Routes() => [
      GetPage(
        name: '/',
        page: () => const Navigation(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/home',
        page: () => const HomeScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/newsfeed',
        page: () => const NewsFeedScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/about',
        page: () => const AboutScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/profile',
        page: () => const ProfileScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
    ];
