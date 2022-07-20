import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/screens/apps_details_page.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

class AppDisplayBox extends StatelessWidget {
  AppDisplayBox({
    Key? key,
    this.applicationTitle,
    this.imagePath,
    this.category,
    this.appId,
  this.ratting,this.developer,this.description,this.iconName,this.link,this.backgroundColor, this.color,
  this.reviewsList, this.downloads
  }) : super(key: key);

  final String? applicationTitle, iconName,appId,description,ratting,developer,link;
  final String? category;
  final String? imagePath;
  final Color ?backgroundColor;
  final String?  color;
  final String? downloads;
  var reviewsList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AppsDetailsPage(
                    color: color,
                    link: link,
                    developer: developer,
                    description: description,
                    appId: appId,
                    applicationTitle: applicationTitle,
                    category: category,
                    iconName: iconName,
                    ratting: ratting,
                    reviewsList: reviewsList,
                    downloads: downloads)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(9.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 3.h,
              spreadRadius: 2.h,
            ),
          ],
          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.grey.shade800:Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: ListTile(
          leading: Container(
            height: 40,
              width: 40,
              decoration: BoxDecoration(shape:BoxShape.circle,image: DecorationImage(image: NetworkImage(iconName.toString()))),),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: applicationTitle, size: 14.sp, fontWeight: FontWeight.w700,color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.white:Colors.black,),
              CustomText(
                  text: category, size: 12.sp, fontWeight: FontWeight.w400,color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.white:Colors.black,),
            ],
          ),
        ),
      ),
    );
  }
}
