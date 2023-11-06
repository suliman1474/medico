// import 'package:medico/screens/onboarding/splash.dart';

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:medico/screens/home.dart';

Routes() => [
      GetPage(
        name: '/',
        page: () => const Home(),
        // HomeScreen(), //ConnectStripeScreen(), //StripePaymentScreen(), //
        transition: Transition.leftToRightWithFade,
        transitionDuration: const Duration(milliseconds: 600),
      ),
    ];
