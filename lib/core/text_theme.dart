import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/app_export.dart';

TextTheme customTexttheme = TextTheme(
  titleLarge: title1,
  titleMedium: title2,
  displayLarge: headline1,
  displayMedium: headline2,
  displaySmall: headline3,
  bodyLarge: bodytext1,
  bodyMedium: bodytext2,
  bodySmall: bodytext3,
  labelSmall: bottombarText,
);

TextStyle title1 = TextStyle(
  fontSize: 30.sp,
  fontWeight: FontWeight.w600,
  color: color1,
);
TextStyle title2 = TextStyle(
  fontSize: 26.sp,
  fontWeight: FontWeight.w700,
  color: textColor,
);
TextStyle headline1 = TextStyle(
  fontSize: 20.sp,
  fontWeight: FontWeight.w700,
  color: textColor,
);
TextStyle headline2 = TextStyle(
  fontSize: 17.sp,
  fontWeight: FontWeight.w700,
  color: textColor,
);
TextStyle headline3 = TextStyle(
  fontSize: 17.sp,
  fontWeight: FontWeight.w600,
  color: textColor,
);
TextStyle bodytext1 = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w500,
  color: textColor,
);
TextStyle bodytext2 = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w400,
  color: textColor,
);
TextStyle bodytext3 = TextStyle(
  fontSize: 15.sp,
  fontWeight: FontWeight.w300,
  color: textColor,
);
TextStyle bottombarText = TextStyle(
  fontSize: 12.sp,
  fontWeight: FontWeight.w700,
  color: offwhite,
);
