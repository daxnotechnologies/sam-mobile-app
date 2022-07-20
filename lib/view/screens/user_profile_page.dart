import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/main.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/add_app.dart';
import 'package:sam_beckman/view/screens/curated/curatedAppsView.dart';
import 'package:sam_beckman/view/screens/favourite_pages.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/reviewdApps.dart';
import 'package:sam_beckman/view/screens/users_view.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

import '../../model/profile.dart';
import 'editProfile_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin{


  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');

  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(duration: Duration(seconds: 1), vsync: this,)..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(1.5, 0.0)).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    super.initState();

    Timer.periodic(Duration(seconds: 2), (timer) async{
      _controller.reset();
     });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 812),
        builder: () =>  Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(3),
          body:  FutureBuilder<dynamic>(
            future: getData(),
            builder: (context, snapshot) {
              return snapshot.hasData ? SlideTransition(
                position: offsetAnimation,
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h),
                              color:SchedulerBinding.instance.window.platformBrightness
                              != Brightness.dark
                                  ? Colors.white
                                  : Colors.grey.shade800,
                              boxShadow: [BoxShadow(color: Colors.black12,spreadRadius: 2,blurRadius: 10)]
                            ),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(20.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: 'My Profile',
                                        size: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      // outlined button with grey borders
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0.r),
                                              side: const BorderSide(color: Colors.grey),
                                            )),
                                        child: CustomText(
                                          text: 'Edit Profile',
                                          size: 12.sp,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          if(FirebaseAuth.instance.currentUser!.email!='guest@gmail.com')
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>editProfile_page(profile: snapshot.data,)));
                                        },                            ),
                                    ],
                                  ),
                                  SizedBox(height: 27.h),
                                  CircleAvatar(
                                    radius: 36.r,
                                    backgroundImage:NetworkImage(snapshot.data!.imagePath),
                                    child:FirebaseAuth.instance.currentUser!.email=='guest@gmail.com'?Container(height:70,width: 70,decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: AssetImage('assets/images/profile.png'),)),):null,
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomText(
                                    text: '${snapshot.data!.name}',
                                    size: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  CustomText(
                                    text: '@${snapshot.data!.username}',
                                    color: const Color.fromARGB(255, 170, 170, 170),
                                    size: 12.sp,
                                  ),
                                  SizedBox(height: 28.h),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 22.h),
                                    padding: EdgeInsets.all(16.h),
                                    decoration: BoxDecoration(
                                      color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.black38: Colors.grey.shade100,
                                      borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>users_view(type: "followers",userId:FirebaseAuth.instance.currentUser!.uid.toString(),)));
                                          },
                                          child: StatsColumn(
                                            title: '${snapshot.data!.followers}',
                                            subTitle: 'Followers',
                                          ),
                                        ),
                                        InkWell(
                                          onTap:(){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>users_view(type: "following",userId:FirebaseAuth.instance.currentUser!.uid.toString(),)));
                                          },
                                          child: StatsColumn(
                                            title: '${snapshot.data!.following}',
                                            subTitle: 'Following',
                                          ),
                                        ),
                                        StatsColumn(
                                          title: '${snapshot.data!.reviews}',
                                          subTitle: 'Reviewed App',
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'Application',
                                size: 20.sp,
                                fontWeight: FontWeight.bold,
                                color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      FirebaseAuth.instance.currentUser!.email!='guest@gmail.com'?
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>addApp())):null;
                                    },
                                    child: CustomText(
                                      text: 'Add App',
                                      size: 12.sp,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Material(
                                    child: InkWell(
                                      onTap: (){
                                        showDialog(context: context, builder: (context) {
                                          isScrollControlled: true;
                                          return Scaffold(
                                            body: FractionallySizedBox(
                                              heightFactor: 0.9,
                                              child: Container(
                                                color: Colors.transparent,
                                                height: MediaQuery.of(context).size.height,
                                                width:  MediaQuery.of(context).size.width,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                          width: 125.w,
                                                          height: 160.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15.0.r),
                                                            color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                            ? Colors.grey.shade800
                                                            :    Color.fromARGB(255, 234, 243, 230),
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/images/funky.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 18.r,
                                                                backgroundColor: Color.fromARGB(255, 255, 64, 89),
                                                                child: Image.asset('assets/icons/heart.png'),
                                                              ),
                                                              SizedBox(height: 30.h),
                                                              CustomText(
                                                                text: snapshot.data!.total.toString(),
                                                                size: 12.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Color.fromARGB(255, 255, 64, 89),
                                                              ),
                                                              SizedBox(height: 5.h),
                                                              CustomText(
                                                                text: 'Application Shelves',
                                                                size: 14.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      SizedBox(height: 20.h,),
                                                      Container(
                                                          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                          width: 125.w,
                                                          height: 160.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15.0.r),
                                                            color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                            ? Colors.grey.shade800
                                                            :    Color.fromARGB(255, 234, 243, 230),
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/images/funky.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 18.r,
                                                                backgroundColor: Color.fromARGB(255, 55, 180, 78),
                                                                child: Image.asset('assets/icons/bookmark.png'),
                                                              ),
                                                              SizedBox(height: 30.h),
                                                              CustomText(
                                                                text: snapshot.data!.favourites.toString(),
                                                                size: 12.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Color.fromARGB(255, 55, 180, 78),
                                                              ),
                                                              SizedBox(height: 5.h),
                                                              CustomText(
                                                                text: 'Curated Application',
                                                                size: 14.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      SizedBox(height: 20.h,),
                                                      Container(
                                                          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                          width: 125.w,
                                                          height: 160.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(15.0.r),
                                                            color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                            ? Colors.grey.shade800
                                                            :    Color.fromARGB(255, 234, 243, 230),
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/images/funky.png"),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 18.r,
                                                                backgroundColor: Color.fromARGB(255, 254, 192, 42),
                                                                child: Image.asset('assets/icons/star.png',),
                                                              ),
                                                              SizedBox(height: 30.h),
                                                              CustomText(
                                                                text: snapshot.data!.reviews.toString(),
                                                                size: 12.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Color.fromARGB(255, 254, 192, 42),
                                                              ),
                                                              SizedBox(height: 5.h),
                                                              CustomText(
                                                                text: 'Latest App Ratings',
                                                                size: 14.sp,
                                                                fontWeight: FontWeight.bold,
                                                                color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                                          ? Colors.white
                                                                          : Colors.black,
                                                                    
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    ],),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(bottom: 10.h),
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(context).primaryColor.withOpacity(0.35),
                                                              spreadRadius: 1,
                                                              blurRadius: 15,
                                                              offset: Offset(0, 8), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        width: 50,
                                                        height: 50,
                                                        child: TextButton(
                                                          onPressed: null,
                                                          child: Center(
                                                            child: Text(  
                                                              'X',
                                                              style: TextStyle(
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                            elevation: 4,
                                                            shadowColor: Theme.of(context).primaryColor,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(40.r),
                                                            ),
                                                          ),
                                                        )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      child: CustomText(
                                        text: 'See All',
                                        size: 12.sp,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 230.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Row(
                              children: [
                                index==0 ? SizedBox(width: 10,) : SizedBox(),
                                InkWell(
                                  onTap: (){
                                    if(index==0){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FavouritesPage()));
                                    }else if(index==1){
                                      if (FirebaseAuth.instance
                                            .currentUser!.email !=
                                        "guest@gmail.com")
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CuratedAppsView(
                                                    docId: "",
                                                    appsList: [],
                                                    appsIconsList: [],
                                                    urlList: [],
                                                    addDialog: false,
                                                    updateDialog: false,
                                                    shelfName: "",
                                                    selectedColor:
                                                        Color(
                                                            0xffd25250),
                                                  )));
                                      // showModalBottomSheet(
                                      //     context: context,
                                      //     isScrollControlled: true,
                                      //     builder: (context) {
                                      //       return FractionallySizedBox(
                                      //           heightFactor: 1,
                                      //           child:curatedAppPage()
                                      //       );
                                      //     });
                                    }else if(index==2){
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                                heightFactor: 1,
                                                child:reviewdAppPage()
                                            );
                                          });
                                    }
                                  },
                                  child: ApplicationWidget(
                                    backgroudColor:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        :  kBackgroundColors[index],
                                    title: kTitle[index],
                                    numbers: index == 1 ? snapshot.data!.favourites.toString() : index == 2 ? snapshot.data!.reviews.toString() : snapshot.data!.total.toString(),
                                    mainColor: kMainColors[index],
                                    iconPaths: kAppsIconsPaths[index],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ) : Container(child: Center(child: CircularProgressIndicator()),);
            }
        )
        ),
      ),
    );
  }









   getData() async{
    // FirebaseFirestore.instance
    //     .collection('users').doc(currentUser!.uid)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc["name"]);
    //   });
    // });
    print(currentUser!.uid);
    var temp = await collectionReference.doc(currentUser!.uid).get();
    print(temp['name']);
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('apps').get();
    final int documents = qSnap.docs.length;
    return Profile(imagePath:temp['imagePath'], password:temp['password'],email:currentUser!.email,web:temp['website'],name: temp['name'], username: temp['username'], favourites: temp['favourites'], reviews: temp['reviews'], total: documents, followers: temp['followers'], following: temp['following']);
    // return profile;
  }


}


class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({
    Key? key,
    this.backgroudColor,
    this.mainColor,
    this.numbers,
    this.title,
    this.iconPaths,
  }) : super(key: key);

  final Color? backgroudColor;
  final Color? mainColor;
  final String? numbers;
  final String? title;
  final String? iconPaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172.w,
      padding: EdgeInsets.all(22.h),
      margin: EdgeInsets.only(right: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0.r),
        color: backgroudColor,
        image: DecorationImage(
          image: AssetImage("assets/images/funky.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: mainColor,
            child: Image.asset(iconPaths!),
          ),
          SizedBox(height: 38.h),
          CustomText(
            text: numbers,
            size: 14.sp,
            fontWeight: FontWeight.w500,
            color: mainColor,
          ),
          CustomText(
            text: title,
            size: 20.sp,
            fontWeight: FontWeight.bold,
            color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ],
      ),
    );
  }
}

class StatsColumn extends StatelessWidget {
  const StatsColumn({
    Key? key,
    this.title,
    this.subTitle,
  }) : super(key: key);

  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: title ?? '',
          size: 18.sp,
          fontWeight: FontWeight.bold,
          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark?Colors.white:Colors.black,
        ),
        SizedBox(height: 6.h),
        CustomText(
          text: subTitle ?? '',
          size: 12.sp,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 170, 170, 170),
        ),
      ],
    );
  }
}
