import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/add_app.dart';
import 'package:sam_beckman/view/screens/user_profile_page.dart';
import 'package:sam_beckman/view/screens/users_view.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

import '../../model/profile.dart';
import 'editProfile_page.dart';

class UserFollowPage extends StatefulWidget {
  UserFollowPage({Key? key, required this.userId}) : super(key: key);

  String? userId;

  @override
  State<UserFollowPage> createState() => _UserFollowPageState();
}

class _UserFollowPageState extends State<UserFollowPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 812),
        builder: () =>  Scaffold(
          body: UserFollowProfilePageBody(userId: widget.userId),
        ),
      ),
    );
  }
}

class UserFollowProfilePageBody extends StatefulWidget {
  UserFollowProfilePageBody({Key? key, required this.userId}) : super(key: key);

  String? userId;

  @override
  State<UserFollowProfilePageBody> createState() => _UserFollowProfilePageBodyState();
}

class _UserFollowProfilePageBodyState extends State<UserFollowProfilePageBody> with SingleTickerProviderStateMixin{

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

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }



  @override
  Widget build(BuildContext context) {  
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
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
                            color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
                                ? Colors.white
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(22.h),
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
                                      text: 'User Profile',
                                      size: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    // outlined button with grey borders
                                    FutureBuilder<bool>(
                                      future: CheckFollow(),
                                      builder: (context,checkSnap) {
                                        return OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15.0.r),
                                                side: const BorderSide(color: Colors.grey),
                                              )),
                                          child:checkSnap.hasData? checkSnap.data==true?CustomText(
                                            text: 'Unfollow',
                                            size: 12.sp,
                                            color: Colors.grey,
                                          ):CustomText(
                                            text: 'Follow',
                                            size: 12.sp,
                                            color: Colors.grey,
                                          ):SizedBox(),
                                          onPressed: () {
                                            if(FirebaseAuth.instance.currentUser!.email!='guest@gmail.com'){
                                             if(checkSnap.data!) {
                                               FirebaseFirestore.instance
                                                   .collection("following").doc(
                                                   FirebaseAuth.instance
                                                       .currentUser!.uid).set(
                                                   {
                                                     'userId': FieldValue
                                                         .arrayRemove(
                                                         [snapshot.data!.id])
                                                   });
                                               FirebaseFirestore.instance.collection('users').doc(widget.userId).update(
                                                   {
                                                     'followers':FieldValue.increment(-1)
                                                   });
                                               FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                                   {
                                                     'following':FieldValue.increment(-1)
                                                   });
                                             }else{ FirebaseFirestore.instance.collection("following").doc(FirebaseAuth.instance.currentUser!.uid).set(
                                                  {
                                                    'userId': FieldValue.arrayUnion([snapshot.data!.id])
                                                  });
                                             FirebaseFirestore.instance.collection('users').doc(widget.userId).update(
                                                 {
                                                   'followers':FieldValue.increment(1)
                                                 });
                                             FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                                 {
                                                   'following':FieldValue.increment(1)
                                                 });
                                            }
                                            }
                                            setState(() {

                                            });
                                          },
                                        );
                                      }
                                    ),
                                  ],
                                ),
                                SizedBox(height: 27.h),
                                CircleAvatar(
                                  radius: 36.r,
                                  backgroundImage:NetworkImage(snapshot.data!['imagePath']),
                                  child:FirebaseAuth.instance.currentUser!.email=='guest@gmail.com'?Container(height:70,width: 70,decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.fill,image: AssetImage('assets/images/profile.png'),)),):null,
                                ),
                                SizedBox(height: 8.h),
                                CustomText(
                                  text: '${snapshot.data!['name']}',
                                  size: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                CustomText(
                                  text: '@${snapshot.data!['username']}',
                                  color: const Color.fromARGB(255, 170, 170, 170),
                                  size: 12.sp,
                                ),
                                SizedBox(height: 28.h),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 22.h),
                                  padding: EdgeInsets.all(16.h),
                                  decoration: BoxDecoration(
                                    color:SchedulerBinding.instance.window.platformBrightness != Brightness.dark
                                        ? Colors.grey.shade200
                                        : Colors.black38,
                                    borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>users_view(type: "followers",userId:widget.userId.toString(),)));
                                        },
                                        child: StatsColumn(
                                          title: '${snapshot.data!['followers']}',
                                          subTitle: 'Followers',
                                        ),
                                      ),
                                      InkWell(
                                        onTap:(){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>users_view(type: "following",userId:widget.userId.toString(),)));
                                        },
                                        child: StatsColumn(
                                          title: '${snapshot.data!['following']}',
                                          subTitle: 'Following',
                                        ),
                                      ),
                                      StatsColumn(
                                        title: '${snapshot.data!['reviews']}',
                                        subTitle: 'Reviewd App',
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
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
                        future: FirebaseFirestore.instance.collection('apps').get(),
                        builder: (context,snap) {
                          return SizedBox(
                            height: 230.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  index==0?SizedBox(width: 10,):SizedBox(),
                                  ApplicationWidget(
                                    backgroudColor: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : kBackgroundColors[index],
                                    title: kTitle[index],
                                    numbers: index == 1 ? snapshot.data!['favourites'].toString() : index == 2 ? snapshot.data!['reviews'].toString() : '0',
                                    mainColor: kMainColors[index],
                                    iconPaths: kAppsIconsPaths[index],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
              ),
            ) : Container(child: Center(child: CircularProgressIndicator()),);
          }
      ),
    );
  }
  Future<bool> CheckFollow()async{
    bool present=false;
    try{
      var userFollowData = await FirebaseFirestore.instance
          .collection("following")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      List followers = userFollowData['userId'];
      followers.forEach((element) {
        if (element == widget.userId) {
          present = true;
        } else {
          present = false;
        }
      });
      return present;
    }catch(ex){
      return false;
    }
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
    var temp = await collectionReference.doc(widget.userId).get();
    print(temp['name']);
    final QuerySnapshot qSnap = await FirebaseFirestore.instance.collection('apps').get();
    final int documents = qSnap.docs.length;
    return Profile(imagePath:temp['imagePath'],password:temp['password'],email:currentUser!.email,web:temp['website'],name: temp['name'], username: temp['username'], favourites: temp['favourites'], reviews: temp['reviews'], total: documents, followers: temp['followers'], following: temp['following']);
    // return profile;
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
           color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black
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
