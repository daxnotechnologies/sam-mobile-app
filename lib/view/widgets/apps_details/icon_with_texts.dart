import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

class IconsWithTexts extends StatelessWidget {
  const IconsWithTexts(
      {Key? key, this.title, this.subtitle, this.iconName, this.isStar = false})
      : super(key: key);

  final String? title;
  final String? subtitle;
  final String? iconName;
  final bool isStar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isStar?Icon(Icons.star,size:30.w,color: Theme.of(context).primaryColor,):Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Icon(Icons.arrow_downward,color: Colors.white,size:18.w,),
        )),
        SizedBox(width: 12.w),
        Column(
          children: [
            CustomText(
              text: title,
              size: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 170, 170, 170),
            ),
            CustomText(
              text: subtitle,
              size: 12.sp,
              fontWeight: FontWeight.bold,
              color:
              SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black
            ),
          ],
        ),
      ],
    );
  }
}
