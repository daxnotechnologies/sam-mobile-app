import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/favController.dart';
import 'package:sam_beckman/controller/searchController.dart';
import 'package:sam_beckman/controller/usersController.dart';
import 'package:sam_beckman/view/screens/followPage.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/search_page.dart';
import 'package:sam_beckman/view/screens/watch_episodes.dart';
import 'package:sam_beckman/view/widgets/apps_details/icon_with_texts.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/rating_dialogue.dart';
import 'package:readmore/readmore.dart';
import 'package:share/share.dart';
import '../../controller/apiService.dart';
import '../../model/popup_model.dart';
import '../widgets/custom_text.dart'; 
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';

import 'login_page.dart';


class AppsDetailsPage extends StatefulWidget {
  AppsDetailsPage(
      {this.ratting,
      this.description,
      this.appId,
      this.category,
      this.applicationTitle,
      this.iconName,
      this.developer,
      this.link,
      this.searchpage,
      this.color,
      this.favColor,
      this.reviewsList,
      this.downloads});
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String? developer;
  final String? link;
  final bool? searchpage;
  final String? color;
  final Color? favColor;
  final String? downloads;
  var reviewsList;
  @override
  State<AppsDetailsPage> createState() => _AppsDetailsPageState(
      description: description,
      appId: appId,
      applicationTitle: applicationTitle,
      category: category,
      iconName: iconName,
      ratting: ratting,
      developer: developer,
      link: link,
      searchPage: searchpage,
      color: color,
      favColor: favColor,
      downloads: downloads,
      reviewsList: reviewsList
      );
}

class _AppsDetailsPageState extends State<AppsDetailsPage> {
  _AppsDetailsPageState(
      {this.ratting,
      this.description,
      this.appId,
      this.category,
      this.applicationTitle,
      this.iconName,
      this.developer,
      this.link,
      this.searchPage,
      this.color,
      this.favColor,
      this.reviewsList,
      this.downloads});
  final String? link;
  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String? developer;
  final bool? searchPage;
  final String? color;
  final Color? favColor;
  final String? downloads;
  var reviewsList;
  @override
  Widget build(BuildContext context) {
    return  AppsDetailsPageBody(
                description: description,
                appId: appId,
                applicationTitle: applicationTitle,
                category: category,
                iconName: iconName,
                ratting: ratting,
                developer: developer,
                link: link,
                searchPage: searchPage,
                color: color,
                favColor: favColor,
                downloads: downloads,
                reviewsList: reviewsList);
  }
}

class AppsDetailsPageBody extends StatefulWidget {
  AppsDetailsPageBody(
      {this.ratting,
      this.description,
      this.appId,
      this.category,
      this.applicationTitle,
      this.iconName,
      this.link,
      this.developer,
      this.searchPage,
      this.color,
      this.favColor,
      this.reviewsList,
      this.downloads});

  final String? appId;
  final String? applicationTitle;
  final String? category;
  final String? iconName;
  final String? description;
  final String? ratting;
  final String? link;
  final String? developer;
  final String? color;
  final bool? searchPage;
  final Color? favColor;
  final String? downloads;
  var reviewsList;
  @override
  State<AppsDetailsPageBody> createState() => _AppsDetailsPageBodyState();
}

class _AppsDetailsPageBodyState extends State<AppsDetailsPageBody> {
  bool detail = true;
  String? video;
  @override
  void initState() {
    userdata();
    getfeaturedVideo();
    // TODO: implement initState
    super.initState();
  }

  getfeaturedVideo() async {
    video = '';
    var app = await FirebaseFirestore.instance
        .collection('apps')
        .doc(widget.appId)
        .get();
    video = app['promo_video'];
    print("Promooooooo Video " + app['promo_video'].toString());
  }

  String name = '';
  String? image;
  var currentUser = FirebaseAuth.instance.currentUser;

  userdata() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    var auth = FirebaseAuth.instance;
    var user = await collectionReference.doc(auth.currentUser!.uid).get();
    name = user['name'];
    image = user['imagePath'];
  }

  var finalRating = 0.0;

  
  @override
  Widget build(BuildContext context) {
    widget.reviewsList.forEach((element) {
      finalRating = finalRating + double.parse(element['ratting'].toString());
      print(finalRating.toString());
    });

    return SafeArea(
      child: ScreenUtilInit(
          designSize:  Size(360, 800),
          builder: () => Scaffold(
          body:Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: OutlinedButton(
                onPressed: () {
                  usersController users = new usersController();
                  searchController controller = new searchController();
                  controller.appList.clear();
                  controller.searchList.clear();
                  controller.Getapps();
                  controller.popular.value = false;
                  controller.older.value = false;
                  controller.latest.value = false;
                  controller.searchitem.value = false;

                  users.videos = APIService.instance.fetchVideosFromPlaylist(
                        playlistId: "PLRpUhZJr8rJ0W8tejKGBhew6J2PxTW3p3");

                  Get.to(Home());
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                  side: const BorderSide(color: Colors.grey),
                )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    CustomText(
                      text: 'Back',
                      size: 12.sp,
                      fontWeight: FontWeight.w500,
                      color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(15, 55, 180, 78),
                      image: DecorationImage(
                          image: NetworkImage(widget.iconName.toString())),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '${widget.applicationTitle}',
                          size: 20.sp,
                          fontWeight: FontWeight.w700,
                          color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: '${widget.category}',
                              size: 12.sp,
                              color: Colors.grey,
                            ),
                            InkWell(
                              highlightColor: Colors.red,
                              onTap: () {
                                favouriteController controller =
                                    Get.put(favouriteController());
                                if (FirebaseAuth.instance.currentUser!.email !=
                                    'guest@gmail.com')
                                  controller.addFav({
                                    'color': widget.color,
                                    'link': widget.link,
                                    "developer": widget.developer,
                                    'description': widget.description,
                                    'appId': widget.appId,
                                    'applicationTitle': widget.applicationTitle,
                                    'category': widget.category,
                                    'iconName': widget.iconName,
                                    'ratting': widget.ratting,
                                    'reviewsList' : widget.reviewsList,
                                    'downloads' : widget.downloads
                                  }, context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 12.r,
                                  child: Icon(
                                    Icons.favorite,
                                    color: widget.favColor == null
                                        ? Colors.red
                                        : widget.favColor,
                                    size: 16.h,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !detail,
                    child: Container(
                      width: 130,
                      height: 50,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              detail = true;
                            });
                          },
                          child: CustomText(
                            text: 'Details',
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: detail,
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                         boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 8), // changes position of shadow
                            ),
                          ],
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          elevation: 10,
                          padding: EdgeInsets.symmetric(
                              horizontal: 34.5.w, vertical: 12.h),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0.r),
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Details',
                            size: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !detail,
                    child: Container(
                      width: 140,
                      height: 50, 
                      decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                         boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 8), // changes position of shadow
                            ),
                          ],
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          elevation: 10,
                          padding: EdgeInsets.symmetric(
                              horizontal: 34.5.w, vertical: 12.h),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0.r),
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            text: 'Reviews',
                            size: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: detail,
                    child: Container(
                      width: 140,
                      height: 50,
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              detail = false;
                            });
                          },
                          child: CustomText(
                            text: 'Reviews',
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print(finalRating);
                      },
                      child: IconsWithTexts(
                        title: '${widget.reviewsList.length.toString()} reviews',
                        iconName: 'star',
                        subtitle: widget.reviewsList.length == 0 ? '0' :
                        (finalRating / (widget.reviewsList.length)).toString() ,
                        isStar: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconsWithTexts(
                      title: 'Downloads',
                      iconName: 'download',
                      subtitle: widget.downloads,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: detail,
              child: Column(children: [
                SizedBox(height: 33.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    onTap: () {
                      if(video.toString().contains("youtu")){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => watch_episodes(
                              video: video,
                              link: widget.link,
                              developer: widget.developer,
                              description: widget.description,
                              appId: widget.appId,
                              applicationTitle: widget.applicationTitle,
                              category: widget.category,
                              iconName: widget.iconName,
                              ratting: widget.ratting,
                              backgroundColor: widget.color,
                              favColor: widget.favColor,
                              episodePage: true,
                              )));
                      }
                      
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 19.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0.r),
                        color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
                            ? Colors.grey.shade200
                            : Colors.grey.shade800,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Watch Feature Episode',
                            size: 12.sp,
                            color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 14,
                                  offset: Offset(0, 4), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 12.r,
                              child: Image.asset(
                                'assets/icons/play.png',
                                width: 6.w,
                                height: 7.h,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ReadMoreText(
                    '${widget.description}',
                    trimLines: 6,
                    textAlign: TextAlign.justify,
                    colorClickableText: Theme.of(context).primaryColor,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Read less',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    moreStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                //
                SizedBox(height: 14.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Developer',
                        size: 12.sp,
                        color: Colors.grey,
                      ),
                      CustomText(
                        text: '${widget.developer.toString()}',
                        size: 12.sp,
                        color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 340.h,
                  width: double.infinity,
                  child: FutureBuilder<List?>(
                      future: GetSlides(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: ((context, index) => Row(
                                  children: [
                                    index == 0
                                        ? SizedBox(
                                            width: 10,
                                          )
                                        : SizedBox(),
                                    Container(
                                      height: 400.h,
                                      width: 180.w,
                                      margin: EdgeInsets.only(right: 15.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                       
                                            // image: NetworkImage(snapshot.data!
                                            //     .elementAt(index)),
                                            // fit: BoxFit.fill),
                                    ),
                                      child:  ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        child: FadeInImage.memoryNetwork(
                                          fit: BoxFit.fill,
                                          placeholder: kTransparentImage,
                                          image: snapshot.data!
                                                  .elementAt(index),
                                        ),
                                      ),
          
                                    ),
                                  ],
                                )),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            getApp();
                          },
                          style: TextButton.styleFrom(
                            shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
                            elevation: 10,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: CustomText(
                            text: 'Get The App',
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Share.share('${widget.link}');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: CustomText(
                            text: 'Share',
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
            Visibility(
                visible: !detail,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: InkWell(
                            onTap: () async{
                                if (FirebaseAuth.instance.currentUser!.email == 'guest@gmail.com') {
                                  var value = await popup(
                                      context,
                                      "Sign in to favourite, \ncurate and review apps.",
                                      "Sign in",
                                      "No thanks");
                                if (value) {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                                }
                              } else {
                                rating_dialogue(context, widget.appId, image);
                              }
                            },
                            child: CustomText(
                                text: 'Add Review',
                                size: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<List?>(
                        future: getReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    DateTime reviewDateTime = snapshot.data!.elementAt(index)['time'].toDate();
                                    var reviewDate = DateFormat('dd MMMM, yyyy').format(reviewDateTime).toString();
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
                                            ? Colors.white
                                            : Colors.grey.shade800,
          
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled: true,
                                                          context: context,
                                                          builder: (context) {
                                                            return FractionallySizedBox(
                                                              heightFactor: 1,
                                                              child: UserFollowPage(
                                                                userId: snapshot
                                                                        .data!
                                                                        .elementAt(
                                                                            index)['userId'],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          image: snapshot.data!
                                                                          .elementAt(
                                                                              index)[
                                                                      'image'] !=
                                                                  null
                                                              ? DecorationImage(
                                                                  image: NetworkImage(snapshot
                                                                      .data!
                                                                      .elementAt(index)[
                                                                          'image']
                                                                      .toString()))
                                                              : DecorationImage(
                                                                  image: AssetImage(
                                                                      'assets/images/profile.png')),
                                                          shape: BoxShape.circle,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                width: 10,
                                              ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${snapshot.data!.elementAt(index)['username']} ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                              SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                                  ? Colors.white
                                                                  : Colors.black,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.verified,
                                                          color: Colors
                                                              .blue.shade600,
                                                          size: 15,
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      reviewDate,
                                                      style: TextStyle(
                                                          //fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 90,
                                                ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                child: Text(
                                                  '${snapshot.data!.elementAt(index)['ratting'].toString().substring(0,1)}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50,
                                                    right: 2,
                                                    top: 8,
                                                    bottom: 8),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.7,
                                                  child: Text(
                                                    '${snapshot.data!.elementAt(index)['description']}',
                                                    maxLines: 100,
                                                    style: TextStyle(
                                                        color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    var likes = snapshot.data!
                                                                .elementAt(
                                                                    index)[
                                                            'likeCount'] +
                                                        1;
                                                    Like(widget.appId, index,
                                                        likes);
                                                    setState(() {
          
                                                    });
                                                  },
                                                  icon: Icon(
                                                    snapshot.data!.elementAt(index)['likes'].contains(currentUser!.uid) ?
                                                    CupertinoIcons.heart_fill : 
                                                    CupertinoIcons.heart,
                                                    color: snapshot.data!.elementAt(index)['likes'].contains(currentUser!.uid) ?
                                                    Colors.red : 
                                                    Colors.grey,
                                                  )),
                                              Text(
                                                '${snapshot.data!.elementAt(index)['likeCount']} Likes',
                                                maxLines: 100,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showComment(widget.appId, index, 
                                                    snapshot.data!.elementAt(index)['image'].toString(),
                                                    snapshot.data!.elementAt(index)['username'].toString(),
                                                    reviewDate,
                                                    snapshot.data!.elementAt(index)['description'],
                                                    snapshot
                                                    .data!
                                                    .elementAt(
                                                        index)['userId']
                                                  );
                                                },
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                          },
                                                          icon: Icon(
                                                            CupertinoIcons.chat_bubble,
                                                            color: Colors.grey,
                                                          )),
                                                      Text(
                                                        '${snapshot.data!.elementAt(index)['commentCount']} Comments',
                                                        maxLines: 100,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Center(
                              child: Text('No review added',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            );
                          }
                        }),
                  ],
                ))
          ],
                ),
              ),
            ))));
  }

  showComment(var appId, var index, var imageUrl, var username, var reviewDate, var review, var userId){
    return showModalBottomSheet(
    context: context, 
    builder: (context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          color: Color(0xff1C1B1F),
          borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0))
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Viewing all replies', style: TextStyle(color: Color(0xffB4B4B4), fontSize: 13.sp),),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel, color: Color(0xffB3B3B3), size: 20),),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return FractionallySizedBox(
                          heightFactor: 1,
                          child: UserFollowPage(
                            userId: userId,
                          ),
                        );
                      });
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      image: imageUrl !=
                              null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl))
                          : DecorationImage(
                              image: AssetImage(
                                  'assets/images/profile.png')),
                      shape: BoxShape.circle,
                      color: Colors.grey),
                ),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color: Color(0xffFFFFFF)
                        ),
                      ),
                      SizedBox(width: 3,),
                      Icon(
                        Icons.verified,
                        color: Colors
                            .blue.shade600,
                        size: 15,
                      ),
                    ],
                  ),
                  Text(
                    reviewDate,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xffB0B0B0)),
                  ),
                ],
              ),
            ],),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 10, 0, 5),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      review.toString(),
                      maxLines: 100,
                      style: TextStyle(
                          color: Color(0xffB7B7B7)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(45, 10, 0, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      addComment(appId, index, imageUrl, username, reviewDate, review, userId);
                    },
                    child: Text('Reply', style: TextStyle(
                      fontWeight : FontWeight.w800,
                      fontSize: 12.sp,
                      color: Color(0xffffffff)
                    ),),
                  ),
                ],
              ),
            ),
            FutureBuilder<List>(
              future: getCommentList(appId, index),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, indexx){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 1,
                                            child: UserFollowPage(
                                              userId: snapshot.data!.elementAt(indexx)['userId'],
                                            ),
                                          );
                                        });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                              image: imageUrl !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(snapshot.data!.elementAt(indexx)['imageUrl']))
                                                  : DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/profile.png')),
                                              shape: BoxShape.circle,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data!.elementAt(indexx)['username'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Color(0xffffffff)
                                                ),
                                              ),
                                              SizedBox(width: 3,),
                                              Icon(
                                                Icons.verified,
                                                color: Colors
                                                    .blue.shade600,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data!.elementAt(indexx)['time'],
                                            style: TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xffB0B0B0)),
                                          ),
                                        ],
                                      ),
                                    ],),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(45, 10, 0, 5),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: Text(
                                        snapshot.data!.elementAt(indexx)['commentDescription'],
                                        maxLines: 100,
                                        style: TextStyle(
                                            color: Color(0xffB7B7B7)
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                  
                  return Container();
                }else {
                  return Container();
                }
              }),
          ],),
        ),
      );
    });
  }

  addComment(var appId, var indexe, var imageUrl, var username, var reviewDate, var review, var userId){
    TextEditingController _addCommentController = new TextEditingController();
    return showModalBottomSheet(
    context: context, 
    builder: (context) {
      return Container(
          height: 600,
          decoration: BoxDecoration(
            color: Color(0xff1C1B1F),
            borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), topLeft: Radius.circular(15.0))
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Replying to', style: TextStyle(color: Color(0xffB4B4B4), fontSize: 13.sp),),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.cancel, color: Color(0xffB3B3B3), size: 20),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 1,
                                child: UserFollowPage(
                                  userId: userId,
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            image: imageUrl !=
                                    null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl))
                                : DecorationImage(
                                    image: AssetImage(
                                        'assets/images/profile.png')),
                            shape: BoxShape.circle,
                            color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Color(0xffffffff)
                              ),
                            ),
                            SizedBox(width: 3,),
                            Icon(
                              Icons.verified,
                              color: Colors
                                  .blue.shade600,
                              size: 15,
                            ),
                          ],
                        ),
                        Text(
                          reviewDate,
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xffB0B0B0)),
                        ),
                      ],
                    ),
                  ],),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(45, 10, 0, 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            review.toString(),
                            maxLines: 100,
                            style: TextStyle(
                                color: Color(0xffB7B7B7)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
      
                ],),
              ),
              
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _addCommentController,
                            style: TextStyle(color: Color(0xffa7a7a7)),
                            minLines: 4,
                            maxLines: 6,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xfff3f3f3),
                              hintText: 'description',
                              hintStyle: TextStyle(
                                color: Color(0xffa7a7a7)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          ),
                        ),
      
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextButton(
                            onPressed: () async{ 
                              DateTime reviewDateTime = DateTime.now();
                              var reviewDatee = DateFormat('dd MMMM, yyyy').format(reviewDateTime).toString();
                              DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('apps').doc(appId).get() as DocumentSnapshot;
                              DocumentSnapshot documentSnapshotUser = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get() as DocumentSnapshot;
                              var reviews =  documentSnapshot['reviews'].toList();

                              reviews[indexe]['comments'].add({
                                'commentDescription' : _addCommentController.text,
                                'imageUrl' : documentSnapshotUser['imagePath'],
                                'time' : reviewDatee,
                                'user' : currentUser!.uid,
                                'username' : documentSnapshotUser['name']
                              });

                              reviews[indexe]['commentCount']  = reviews[indexe]['commentCount'] + 1;

                              await FirebaseFirestore.instance
                                .collection('apps')
                                .doc(appId)
                                .update({'reviews': reviews});

                              _addCommentController.text = "";
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                            ),
                            child: CustomText(
                              text: 'Submit Comment',
                              size: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],),
                    ),
                  ),  
            ],
          ),
      );
    });
  }

  Future<List> getCommentList(var appId, var index) async{
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('apps')
          .doc(appId).get() as DocumentSnapshot;
    
    return documentSnapshot['reviews'][index]['comments'];
  }

  Future<List?> GetSlides() async {
    List? list;
    await FirebaseFirestore.instance
        .collection('apps')
        .doc(widget.appId)
        .get()
        .then((DocumentSnapshot querySnapshot) {
      list = querySnapshot['screenshots'];
      return list;
    });
    return list;
  }

  getApp() async {
    await LaunchApp.openApp(
        appStoreLink: '${widget.link}',
        androidPackageName:
            '${widget.link!.replaceAll('https://play.google.com/store/apps/details?id=', "")}');
  }

  Future<List?> getReviews() async {
    List? list;
    await FirebaseFirestore.instance
        .collection('apps')
        .doc(widget.appId)
        .get()
        .then((DocumentSnapshot querySnapshot) {
      list = querySnapshot['reviews'];
      return list;
    });
    return list;
  }

  Like(var appid, index, var likes) async {

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('apps')
          .doc(appid).get() as DocumentSnapshot;

      var reviews =  documentSnapshot['reviews'].toList();

      if(reviews[index]['likes'].toList().contains(currentUser!.uid)){
          reviews[index]['likes'].remove(currentUser!.uid);

          reviews[index]['likeCount'] = reviews[index]['likeCount'] - 1;
          await FirebaseFirestore.instance
              .collection('apps')
              .doc(appid)
              .update({'reviews': reviews});
      } else {
          log("Beforeee");
          log(reviews[index]['likes'].toList().toString());
          reviews[index]['likes'].add(currentUser!.uid);
          log(reviews[index]['likes'].toList().toString());
          reviews[index]['likeCount'] = reviews[index]['likeCount'] + 1;

          await FirebaseFirestore.instance
              .collection('apps')
              .doc(appid)
              .update({'reviews': reviews});
      }

      setState(() {
          
      });

     
  }
}
