import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

class episodeIconsWithTexts extends StatelessWidget {
  const episodeIconsWithTexts(
      {Key? key, this.title, this.subtitle, this.iconName, this.isView,this.isLike})
      : super(key: key);

  final String? title;
  final String? subtitle;
  final String? iconName;
  final bool ?isLike;
  final bool ?isView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLike! ?Icon(Icons.thumb_up,size:25.w,color: Theme.of(context).primaryColor,):isView!?Icon(Icons.remove_red_eye,size:25.w,color: Theme.of(context).primaryColor,):Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Icon(Icons.arrow_upward_sharp,color: Colors.white,size:18.w,),
            )),
        SizedBox(width: 10,),
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
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ],
        ),
      ],
    );
  }
}
