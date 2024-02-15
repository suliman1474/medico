import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/routes.dart';
import 'package:medico/services/firebase_notifications.dart';

import 'binding.dart';
import 'core/text_theme.dart';
import 'firebase_options.dart';

Future<void> execute(
  InternetConnectionChecker internetConnectionChecker,
) async {
  // Simple check to see if we have Internet
  // ignore: avoid_print
  print('''The statement 'this machine is connected to the Internet' is: ''');
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  // ignore: avoid_print
  print(
    isConnected.toString(),
  );
  // returns a bool

  // We can also get an enum instead of a bool
  // ignore: avoid_print
  print(
    'Current status: ${await InternetConnectionChecker().connectionStatus}',
  );
  // Prints either InternetConnectionStatus.connected
  // or InternetConnectionStatus.disconnected

  // actively listen for status updates
  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          // ignore: avoid_print
          ;
          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          ;
          break;
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  // await listener.cancel();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotifications().initNotifications();

  DbController db = Get.put(DbController());
  await db.initialize();

  // Check internet connection with singleton (no custom values allowed)
  //await execute(InternetConnectionChecker());

  // Create customized instance which can be registered via dependency injection
  // final InternetConnectionChecker customInstance =
  //     InternetConnectionChecker.createInstance(
  //   checkTimeout: const Duration(seconds: 1),
  //   checkInterval: const Duration(seconds: 1),
  // );

  // Check internet connection with created instance
  //await execute(customInstance);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color1));

    runApp(MyApp() // Wrap your app
        );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(424, 917),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          title: 'Medico',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: customTexttheme.apply(
              fontSizeFactor: 1.sp,
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: color1,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: white),
            useMaterial3: true,
          ),
          initialBinding: Binding(),
          initialRoute: '/splash',
          getPages: Routes(),
        );
      },
    );
  }
}
