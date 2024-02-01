import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

class CustomFileTile extends StatelessWidget {
  final String itemName;
  // final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final bool? downloadable;

  CustomFileTile({
    super.key,
    required this.itemName,
    // this.onRename,
    this.onDelete,
    this.downloadable = true,
  });

  @override
  Widget build(BuildContext context) {
    return downloadable!
        ? Stack(
            alignment: Alignment.centerRight,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 1,
                  sigmaY: 1,
                  tileMode: TileMode.decal,
                ),
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
                    // width: 379.w,
                    height: 76.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20).r,
                      color: secondryColor,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.all(10).w,
                            width: 45.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).r,
                              color: color2,
                            ),
                            child: CustomImageView(
                              svgPath: IconConstant.icFile,
                              height: 30.h,
                              width: 30.w,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
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
                        PopupMenuButton<String>(
                          position: PopupMenuPosition.under,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            // if (value == 'rename' && onRename != null) {
                            //   onRename!();
                            // } else
                            if (value == 'Delete' && onDelete != null) {
                              onDelete!();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Delete'].map((String choice) {
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
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 25.w),
                child: MaterialButton(
                  color: color1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                  onPressed: () {},
                  child: Text(
                    'Download',
                    style: customTexttheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        : Container(
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
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(10).w,
                    width: 45.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15).r,
                      color: color2,
                    ),
                    child: CustomImageView(
                      svgPath: IconConstant.icFile,
                      height: 30.h,
                      width: 30.w,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
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
                PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    // if (value == 'rename' && onRename != null) {
                    //   onRename!();
                    // } else
                    if (value == 'Delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return ['Delete'].map((String choice) {
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
