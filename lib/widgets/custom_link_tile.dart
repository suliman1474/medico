import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../constants/user_role.dart';
import '../controllers/db_controller.dart';

class CustomLinkTile extends StatelessWidget {
  final String itemName;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  CustomLinkTile({
    super.key,
    required this.itemName,
    this.onRename,
    this.onDelete,
  });
  DbController dbController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
        // width: 379.w,
        height: 76.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20).r,
          color: secondryColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(10).w,
                width: 45.w,
                height: 55.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15).r,
                  color: color2,
                ),
                child: CustomImageView(
                  svgPath: IconConstant.icLink,
                  // height: 45.h,
                  // width: 45.w,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  itemName,
                  style: customTexttheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            if (dbController.userRole.value == UserRole.ADMIN)
              PopupMenuButton<String>(
                position: PopupMenuPosition.under,
                constraints: BoxConstraints(
                  maxHeight: 400.h,
                  maxWidth: 205.w,
                ),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  print('on select value: $value');
                  if (value == 'Edit' && onRename != null) {
                    onRename!();
                  } else if (value == 'Delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ['Delete', 'Edit'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: customTexttheme.bodyLarge,
                      ),
                    );
                  }).toList();
                },
              ),
          ],
        ));
  }
}
