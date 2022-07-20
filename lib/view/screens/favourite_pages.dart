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

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(360, 812),
          builder: () => Scaffold(
            bottomNavigationBar: CustomBottomNavigationBar(1),
            body: FavouritesPageBody(),
          ),
        ));
  }
}

class FavouritesPageBody extends StatefulWidget {
  FavouritesPageBody({Key? key}) : super(key: key);

  @override
  State<FavouritesPageBody> createState() => _FavouritesPageBodyState();
}

class _FavouritesPageBodyState extends State<FavouritesPageBody> {


  @override
  void initState() {
    controller.Fav_appList.clear();
    controller.Fav_appList1.clear();
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
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'All Your ',
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
                      text: 'Favourites ',
                      style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28),
                          color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: 'Applications',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(28),
                        color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),


              // ListView(scrollDirection: Axis.horizontal, children: const [
              //   AppContainer(),
              //   AppContainer(),
              // ]),
              SizedBox(
              height: 170.h,
              child:
              FutureBuilder<dynamic>(
                  future: controller.GetUpperapps(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          print(controller.Fav_appList1.elementAt(index).reviewsList.toString());
                          return AppContainer(
                            color: controller.Fav_appList1
                                .elementAt(index).color,
                            applicationTitle: controller.Fav_appList1
                                .elementAt(index)
                                .applicationTitle,
                            category: controller.Fav_appList1
                                .elementAt(index)
                                .category,
                            backgroundColor:Color(int.parse('0xff${ controller.Fav_appList1
                                .elementAt(index).color}')),
                            iconName: controller.Fav_appList1
                                .elementAt(index)
                                .iconName,
                            appId: controller.Fav_appList1
                                .elementAt(index)
                                .appId,
                            description: controller.Fav_appList1
                                .elementAt(index)
                                .description,
                            ratting: controller.Fav_appList1
                                .elementAt(index)
                                .ratting
                                .toString(),
                            developer: controller.Fav_appList1
                                .elementAt(index)
                                .developer
                                .toString(),
                            link: controller.Fav_appList1
                                .elementAt(index)
                                .link
                                .toString(),
                            downloads: controller.Fav_appList1
                                .elementAt(index)
                                .downloads
                                .toString(),
                            reviewsList: controller.Fav_appList1
                                .elementAt(index)
                                .reviewsList,
                          );}),
                        itemCount: controller.Fav_appList1.length,
                        shrinkWrap: true,
                      );
                    } else {
                      return Container(child: Center(child: CircularProgressIndicator()),);
                    }

                  }
              ),
            ),
            
            SizedBox(height: 35.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17.r,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 15.h,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  CustomText(
                    text: 'All Favourites Applications',
                    size: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.w700,
                    color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder<dynamic>(
                  future: controller.Getapps(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
                          itemBuilder: ((context, index) {
                          print(controller.Fav_appList.elementAt(index).reviewsList.toString());
                          return AppDisplayBox(
                            color: controller.Fav_appList
                                .elementAt(index).color,
                            imagePath: controller.Fav_appList.elementAt(index).imagePath,
                            applicationTitle: controller.Fav_appList
                                .elementAt(index)
                                .applicationTitle,
                            category: controller.Fav_appList
                                .elementAt(index)
                                .category,
                            backgroundColor:Color(int.parse('0xff${ controller.Fav_appList
                                .elementAt(index).color}')),
                            iconName: controller.Fav_appList
                                .elementAt(index)
                                .iconName,
                            appId: controller.Fav_appList
                                .elementAt(index)
                                .appId,
                            description: controller.Fav_appList
                                .elementAt(index)
                                .description,
                            ratting: controller.Fav_appList
                                .elementAt(index)
                                .ratting
                                .toString(),
                            developer: controller.Fav_appList
                                .elementAt(index)
                                .developer
                                .toString(),
                            link: controller.Fav_appList
                                .elementAt(index)
                                .link
                                .toString(), 
                            downloads: controller.Fav_appList
                                .elementAt(index)
                                .downloads
                                .toString(), 
                            reviewsList: controller.Fav_appList
                                .elementAt(index)
                                .reviewsList,
                          );}),
                        itemCount: controller.Fav_appList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    } else {
                      return Container(child: Center(child: CircularProgressIndicator()),);
                    }

                  }
            ),
              ),
          ],
        ),
      ),
    );
  }


}

class AppContainer extends StatelessWidget {
  AppContainer({
    this.appId,
    this.applicationTitle,
    this.category,
    this.iconName,
    this.backgroundColor,
    this.description,
    this.ratting,
    this.developer,
    this.link,
    this.color,
    this.reviews,
    this.favColor,
    this.reviewsList,
    this.downloads });

  final String?color;
  final String? link;
  final String? developer;
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final Color? backgroundColor;
  final String? reviews;
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
                    reviewsList: reviewsList,
                    downloads: downloads)));
      },
      child: Container(
        width: 262.w,
        height: 160.h,
        margin: EdgeInsets.only(left: 20.w),
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 1,blurRadius: 1)],
          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.grey.shade800:backgroundColor,
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
                          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.white:Colors.black,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),
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
                        'color':color,
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
                    Future.delayed(Duration(seconds: 1)).then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FavouritesPage())));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.r,
                      child: Icon(
                        Icons.favorite,
                        color: favColor == null ? Colors.grey : favColor,
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