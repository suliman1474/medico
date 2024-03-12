import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/custom_elevated_button.dart';
import 'package:medico/widgets/custom_image_view.dart';

class UserDetailScreen extends StatefulWidget {
  UserModel user;
  UserDetailScreen({super.key, required this.user});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late bool blocked;
  AuthenticationController authController = Get.find();

  @override
  void initState() {
    super.initState();
    blocked = widget.user.blocked;
  }

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
          actions: [
            CustomElevatedButton(
              onTap: () {
                !blocked
                    ? authController.blockUser(widget.user.id)
                    : authController.unblockUser(widget.user.id);
                setState(() {
                  blocked = !blocked;
                });
              },
              text: !blocked ? 'Block' : 'Unblock',
              buttonTextStyle: customTexttheme.bodyLarge!.copyWith(
                color: white,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                side: BorderSide.none,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).r,
              ),
              height: 40.h,
              width: 80.w,
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            ),
          ],
        ),
        body: Container(
          height: 250.h,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: secondryColor,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    height: 65.h,
                    width: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(33.r),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image!,
                          placeholder: (context, url) => Image(
                            image: AssetImage(IconConstant.icTopbarProfile),
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage(IconConstant.icTopbarProfile),
                            fit: BoxFit.cover,
                          ),
                        )
                        // widget.user.image!.isNotEmpty
                        //     ? Image.network(
                        //         widget.user.image!,
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Image.asset(
                        //         IconConstant.icTopbarProfile,
                        //         fit: BoxFit.cover,
                        //       ),
                        ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style: customTexttheme.titleLarge!.copyWith(
                              color: textColor,
                            ),
                          ),
                          Text(
                            widget.user.email,
                            style: customTexttheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        svgPath: IconConstant.icCollege,
                        height: 20.h,
                        width: 20.w,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        widget.user.college,
                        style: customTexttheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageView(
                        svgPath: IconConstant.icDegree,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        widget.user.discipline,
                        style: customTexttheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomImageView(
                      svgPath: IconConstant.icContact,
                      height: 20.h,
                      width: 20.w,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      widget.user.contact,
                      style: customTexttheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
