import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

class CategoriesBox extends StatelessWidget {
  const CategoriesBox({
    Key? key,
    this.title,
    this.imagePath,
  }) : super(key: key);

  final String? title;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0),
            blurRadius: 3.h,
            spreadRadius: 2.h,
          ),
        ],
        color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark?Colors.white:Colors.grey.shade700,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/icons/categories/$imagePath.png',
            width: 48.w,
            height: 48.h,
          ),
          SizedBox(height: 6.h),
          CustomText(
              text: title ?? '', size: 14.sp, fontWeight: FontWeight.w600,color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.white:Colors.black,),
        ],
      ),
    );
  }
}
