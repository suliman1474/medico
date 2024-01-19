import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/routes.dart';
import 'package:medico/services/firebase_notifications.dart';

import 'binding.dart';
import 'core/text_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DbController db = Get.put(DbController());
  await db.initialize();
  await FirebaseNotifications().initNotifications();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color1));

    runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ));
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
