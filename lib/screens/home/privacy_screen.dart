import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/text_theme.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_circle_left_outlined,
              color: color1,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Privacy Policy',
            style: customTexttheme.titleLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: secondryColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '''

Medico Slides is committed to protecting the privacy of its users. This Privacy Policy outlines the types of personal information collected by the app, how it is used, and how it is protected.
        
Information Collection and Use:
        
- Personal Information:
Medico Slides may collect personal information such as name, email address, and educational institution affiliation. This information is collected solely for the purpose of providing personalized services within the app and improving the user experience.
        
- Usage Data:
The app may also collect usage data, such as pages visited and interactions within the app, to analyze and improve the app's performance and features.
        
- Data Security:        
Medico Slides employs industry-standard security measures to protect the personal information of its users. This includes encryption of data transmission, secure storage practices, and access controls to prevent unauthorized access to user data.
        
- Third-Party Services:
The app may integrate third-party services for analytics, advertising, or other functionalities. These services may collect and process personal information according to their own privacy policies. Users are encouraged to review the privacy policies of these third-party services.
        
- Data Sharing:
Medico Slides does not sell, trade, or otherwise transfer personal information to third parties without user consent, except as required by law or as necessary to provide the app's services.
        
- Updates to Privacy Policy:
This Privacy Policy may be updated from time to time to reflect changes in our practices or applicable laws. Users will be notified of any significant changes to the Privacy Policy within the app.
        
- Contact Us:
If you have any questions or concerns about this Privacy Policy or the app's data practices, please contact us at [ medicoslidesofficial@gmail.com ].''',
              style: customTexttheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
