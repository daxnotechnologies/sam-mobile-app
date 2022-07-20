import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/favController.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:sam_beckman/view/widgets/search_page/apps_display_container.dart';

import 'apps_details_page.dart';

class reviewdAppPage extends StatefulWidget {
  const reviewdAppPage({Key? key}) : super(key: key);

  @override
  State<reviewdAppPage> createState() => _reviewdAppPageState();
}

class _reviewdAppPageState extends State<reviewdAppPage> {

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(360, 812),
          builder: () => SafeArea(
            child: Scaffold(
              body: ReviewdAppPageBody(),
            ),
          ),
        ));
  }
}

class ReviewdAppPageBody extends StatefulWidget {
  ReviewdAppPageBody({Key? key}) : super(key: key);

  @override
  State<ReviewdAppPageBody> createState() => _ReviewdAppPageBodyState();
}

class _ReviewdAppPageBodyState extends State<ReviewdAppPageBody> {


  @override
  void initState() {
    controller.reviewd_appList.clear();
    // TODO: implement initState
    super.initState();
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  favouriteController controller=Get.put(favouriteController());


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your App ',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(28),
                        color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Ratings ',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28),
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FutureBuilder<dynamic>(
                  future: controller.GetRattedapps(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: ((context, index) {
                          return AppDisplayBox(
                            color: controller.reviewd_appList
                                .elementAt(index).color,
                            imagePath: controller.reviewd_appList.elementAt(index).imagePath,
                            applicationTitle: controller.reviewd_appList
                                .elementAt(index)
                                .applicationTitle,
                            category: controller.reviewd_appList
                                .elementAt(index)
                                .category,
                            iconName: controller.reviewd_appList
                                .elementAt(index)
                                .iconName,
                            appId: controller.reviewd_appList
                                .elementAt(index)
                                .appId,
                            description: controller.reviewd_appList
                                .elementAt(index)
                                .description,
                            ratting: controller.reviewd_appList
                                .elementAt(index)
                                .ratting
                                .toString(),
                            developer: controller.reviewd_appList
                                .elementAt(index)
                                .developer
                                .toString(),
                            link: controller.reviewd_appList
                                .elementAt(index)
                                .link
                                .toString(),
                            downloads: controller.reviewd_appList
                              .elementAt(index)
                              .downloads
                              .toString(),
                            reviewsList: controller.reviewd_appList
                                .elementAt(index)
                                .reviewsList,
                          );}),
                        itemCount: controller.reviewd_appList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    } else {
                      return Container(child: Center(child: CircularProgressIndicator()),);
                    }

                  }
              ),
            ),
            // FutureBuilder<dynamic>(
            //   future: FirebaseFirestore.instance.collection('apps').get(),
            //   builder: (context, snapshot) {
            //     if(snapshot.hasData) {
            //         return ListView.builder(
            //         itemBuilder: ((context, index) {
            //           return AppDisplayBox(
            //             applicationTitle: snapshot.data!.docs.elementAt(index)['title'],
            //             category:  snapshot.data!.docs.elementAt(index)['category'],
            //             backgroundColor: kAppIconsColors[index],
            //             iconName: snapshot.data!.docs.elementAt(index)['icon'],
            //             appId: snapshot.data!.docs.elementAt(index).id,
            //             description: snapshot.data!.docs.elementAt(index)['description'],
            //             ratting: snapshot.data!.docs.elementAt(index)['rating'].toString(),
            //             developer:snapshot.data!.docs.elementAt(index)['developer'].toString(),
            //             link: snapshot.data!.docs.elementAt(index)['playStoreLink'].toString(),
            //           );}),
            //         itemCount: snapshot.data!.docs.length,
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //       );
            //     } else {
            //       return Container(child: Center(child: CircularProgressIndicator()),);
            //     }
            //
            //   }
            // ),
          ],
        ),
      ),
    );
  }


}

class AppContainer extends StatelessWidget {
  AppContainer({
    Key? key,
    this.applicationTitle,
    this.imagePath,
    this.category,
    this.appId,
    this.ratting,this.developer,this.description,this.iconName,this.link,this.backgroundColor, this.favColor,
    required this.color, this.reviewsList, this.downloads
  }) : super(key: key);

  final String? applicationTitle, iconName,appId,description,ratting,developer,link;
  final String? category;
  final String? imagePath;
  final Color ?backgroundColor;
  final String? color;
  final Color? favColor;
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
                    developer: this.developer,
                    description: description,
                    appId: appId,
                    applicationTitle: applicationTitle,
                    category: category,
                    iconName: iconName,
                    ratting: ratting,
                    downloads: downloads,
                    reviewsList: reviewsList)));
      },
      child: Container(
        width: 262.w,
        height: 160.h,
        margin: EdgeInsets.only(left: 20.w),
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.0.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(iconName!),
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          text: applicationTitle ?? '',
                          size: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
            CustomText(
              text: 'Category',
              size: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: 'Category: $category',
                    size: 12.sp,
                    color: Colors.white),
                InkWell(
                  highlightColor: Colors.red,
                  onTap: () {
                    favouriteController controller =
                    Get.put(favouriteController());
                    if(FirebaseAuth.instance.currentUser!.email!='guest@gmail.com')
                      controller.addFav({
                        'link': link,
                        "developer": developer,
                        'description': description,
                        'appId': appId,
                        'applicationTitle': applicationTitle,
                        'category': category,
                        'iconName': iconName,
                        'ratting': ratting,
                        'reviewsList' : reviewsList,
                        'downloads' : downloads
                      }, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.r,
                      child: Icon(
                        Icons.favorite,
                        color: favColor,
                        size: 16.h,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}