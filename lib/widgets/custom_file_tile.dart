import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFileTile extends StatelessWidget {
  final String itemName;
  // final VoidCallback? onRename;
  final VoidCallback? onDelete;

  CustomFileTile({
    super.key,
    required this.itemName,
    // this.onRename,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
      // width: 379.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
// Set the background color
        borderRadius: BorderRadius.circular(10.0), // Set the border radius
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: Icon(Icons.description), // Replace with your desired icon
        title: Row(
          children: [
            Flexible(
              child: Text(
                itemName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Spacer(),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            // if (value == 'rename' && onRename != null) {
            //   onRename!();
            // } else
            if (value == 'delete' && onDelete != null) {
              onDelete!();
            }
          },
          itemBuilder: (BuildContext context) {
            return ['delete'].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}