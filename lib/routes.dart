// import 'package:medico/screens/onboarding/splash.dart';

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:medico/screens/Authentication/login_screen.dart';
import 'package:medico/screens/Authentication/signup_screen.dart';
import 'package:medico/screens/home/about_screen.dart';
import 'package:medico/screens/home/home_screen.dart';
import 'package:medico/screens/home/main_page.dart';
import 'package:medico/screens/home/news_feed_screen.dart';
import 'package:medico/screens/home/profile_screen.dart';
import 'package:medico/screens/home/splash_screen.dart';

Routes() => [
      GetPage(
        name: '/',
        page: () => const MainPage(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/splash',
        page: () => const SplashScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/login',
        page: () => const LoginScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
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
      GetPage(
        name: '/signup',
        page: () => const SignUpScreen(),
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
    ];
