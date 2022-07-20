import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/view/screens/favourite_pages.dart';
import 'package:sam_beckman/view/screens/search_page.dart';
import 'package:sam_beckman/view/widgets/search_page/apps_display_container.dart';

import '../widgets/bottom_navigation_bar.dart';
import 'apps_details_page.dart';
import 'home_page.dart';

class ShowCategories extends StatefulWidget {
  ShowCategories({Key? key, required this.categoryValue}) : super(key: key);

  String categoryValue;

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(1.5, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    super.initState();

    Timer.periodic(Duration(seconds: 2), (timer) async {
      _controller.reset();
    });
  }

  Future<bool> _onWillPop() async {
    return Future.delayed(Duration(milliseconds: 1), () {
      Get.to(Home());
      return false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
              bottomNavigationBar: SlideTransition(
                  position: offsetAnimation, child: CustomBottomNavigationBar(1)),
              body: CategoriesBody(
                category: widget.categoryValue,
              )),
        ),
      ),
    );
  }
}

class CategoriesBody extends StatelessWidget {
  CategoriesBody({Key? key, required this.category}) : super(key: key);
  String category;

  List<String>? fav_list = [];

  @override
  Widget build(BuildContext context) {
    fav_list = [];

    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => FutureBuilder<List<String>>(
            future: getFavouriteApps(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                fav_list = snapshots.data;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${category}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                            TextSpan(
                              text: ' Applications',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil().setSp(28),
                                color: SchedulerBinding.instance.window
                                            .platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('apps')
                            .where('category', isEqualTo: category)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              width: double.infinity,
                              height: 160.h,
                              child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal, 
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs.map((document) {
                                    if (snapshot.hasData) {
                                      var backColor =
                                          int.parse("0xff${document['color']}");
                                      var favColor = Colors.grey;

                                      if(snapshots.data!.contains(document['title'])){
                                        favColor = Colors.red;
                                        snapshots.data!.remove(document['title']);
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AppsDetailsPage(
                                                    favColor: favColor,
                                                    color: document['color'],
                                                    description: document['description'],
                                                    ratting:
                                                        document['rating'].toString(),
                                                    developer: document['developer'],
                                                    link: document['playStoreLink'],
                                                    appId: document.id,
                                                    applicationTitle: document['title'],
                                                    category: document['category'],
                                                    iconName: document['icon'],
                                                    downloads: document['downloads'].toString(),
                                                    reviewsList: document['reviews'])));
                                        },
                                        child: AppContainer(
                                          backgroundColor: Color(backColor),
                                          color: document['color'],
                                          applicationTitle: document['title'],
                                          category: document['category'],
                                          iconName: document['icon'],
                                          appId: document.id,
                                          description: document['description'],
                                          ratting:
                                              document['rating'].toString(),
                                          developer: document['developer'],
                                          link: document['playStoreLink'],
                                          favColor: favColor,
                                          downloads: document['downloads'].toString(),
                                          reviewsList: document['reviews']
                                        ),
                                      );
                                    } else
                                      return Container();
                                  }).toList()),
                            );
                          } else
                            return Container();
                        }),
                        SizedBox(height: 30.h),

                        StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('apps')
                            .where('category', isEqualTo: category)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs.map((document) {
                                    if (snapshot.hasData) {
                                      var backColor =
                                          int.parse("0xff${document['color']}");

                                      var favColor = Colors.grey;
                                      

                                      if(fav_list!.contains(document['title'])){
                                        favColor = Colors.red;
                                        fav_list!.remove(document['title']);
                                      }
                                      
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AppsDetailsPage(
                                                    favColor: favColor, 
                                                    color: document['color'],
                                                    description: document['description'],
                                                    ratting:
                                                        document['rating'].toString(),
                                                    developer: document['developer'],
                                                    link: document['playStoreLink'],
                                                    appId: document.id,
                                                    applicationTitle: document['title'],
                                                    category: document['category'],
                                                    iconName: document['icon'],
                                                    downloads: document['downloads'].toString(),
                                                    reviewsList: document['reviews'])));
                                          },
                                          child: AppDisplayBox(
                                              backgroundColor: Color(backColor),
                                              color: document['color'],
                                              applicationTitle: document['title'],
                                              category: document['category'],
                                              iconName: document['icon'],
                                              appId: document.id,
                                              description: document['description'],
                                              ratting:
                                                  document['rating'].toString(),
                                              developer: document['developer'],
                                              link: document['playStoreLink'],
                                              downloads: document['downloads'].toString(),
                                              reviewsList: document['reviews']
                                          ),
                                        ),
                                      );
                                    } else
                                      return Container();
                                  }).toList()),
                            );
                          } else
                            return Container();
                        }),
                  ],
                );
              } else
                return Container();
            }));
  }

  Future<List<String>> getFavouriteApps() async {
    List<String> Fav_appList1 = <String>[];
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance.collection('favourites');
    var Mapapps = await collection.doc(auth.currentUser!.uid).get();
    List Listapps = [];
    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['appList'];
    Fav_appList1.isEmpty
        ? Listapps.forEach((element) {
            Fav_appList1.add(element['applicationTitle'].toString());
          })
        : null;
    return Fav_appList1;
  }
}
