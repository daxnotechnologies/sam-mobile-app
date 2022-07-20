import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/favController.dart';
import 'package:sam_beckman/controller/usersController.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/followPage.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:sam_beckman/view/widgets/search_page/apps_display_container.dart';

import 'apps_details_page.dart';

class users_view extends StatefulWidget {
  users_view({this.userId,this.type});
  String?userId;
  String?type;
  @override
  _users_viewState createState() => _users_viewState();
}

class _users_viewState extends State<users_view> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var currentUser = FirebaseAuth.instance.currentUser;

  usersController controller=Get.put(usersController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 812),
        builder: () => SafeArea(
            child: Scaffold(
                body:Container(
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
                                  text:  widget.type=="followers"?'Followers:':'Followings:',
                                  style: TextStyle(
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
                          child: FutureBuilder<List>(
                              future: widget.type=="followers"?controller.GetFollowers(widget.userId):controller.GetFollowings(widget.userId),
                              builder: (context, snapshot) {
                                if(snapshot.hasData) {
                                  return ListView.builder(
                                    itemBuilder: ((context, index) {
                                      return FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance.collection('users').doc(snapshot.data!.elementAt(index)).get(),
                                          builder: (context,snapshot2) {
                                            if(snapshot2.hasData) {
                                              return InkWell(
                                                onTap: (){
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserFollowPage(userId: snapshot2.data!.id)));
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
                                                    color: SchedulerBinding.instance.window
                                                        .platformBrightness ==
                                                        Brightness.dark
                                                        ? Colors.grey.shade800
                                                        : Colors.white,
                                                    borderRadius: BorderRadius.circular(15.r),
                                                  ),
                                                  child: ListTile(
                                                    leading: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  "${snapshot2.data!['imagePath'] != null ? snapshot2.data!['imagePath'].toString() : ""}"))),
                                                    ),
                                                    title: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        CustomText(
                                                          text:
                                                          "${snapshot2.data!['name'] != null ? snapshot2.data!['name'].toString() : ""}",
                                                          size: 14.sp,
                                                          fontWeight: FontWeight.w700,
                                                          color: SchedulerBinding
                                                              .instance
                                                              .window
                                                              .platformBrightness ==
                                                              Brightness.dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }else{
                                              return Container();
                                            }
                                          });
            
                                    }),
            
                                    itemCount: controller.usersList.length,
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
                ))));
  }

}
