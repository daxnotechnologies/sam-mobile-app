import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/searchController.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/apps_details_page.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:sam_beckman/view/widgets/search_page/apps_display_container.dart';
import 'package:string_extensions/string_extensions.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.filterValue}) : super(key: key);

  String filterValue;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(2),
          body: SearchPageBody(filterValue: widget.filterValue,),
        ),
      ),
    );
  }
}

class SearchPageBody extends StatefulWidget {
  SearchPageBody({Key? key, required this.filterValue}) : super(key: key);

  String filterValue;

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  TextEditingController? _searchController = new TextEditingController();
  searchController controller = Get.put(searchController());
  var query = FirebaseFirestore.instance.collection('apps').snapshots();

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filterValue = "Filter By";

    return Container(
      margin: EdgeInsets.all(10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Find Your Favourite',
            fontWeight: FontWeight.w700,
            size: ScreenUtil().setSp(28),
            color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          CustomText(
              text: 'Application',
              fontWeight: FontWeight.w700,
              size: ScreenUtil().setSp(28),
              color: Theme.of(context).primaryColor),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.h),
                // outlined border for search bar
                decoration: BoxDecoration(
                  border: Border.all(
                    color: SchedulerBinding
                        .instance.window.platformBrightness ==
                        Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    width: 1.h,
                  ),
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    SizedBox(
                      width: 160.w,
                      height: 19.h,
                      child: TextFormField(
                        onChanged: (value) {
                          if (value.length != 0) {
                            value = value.toTitleCase!;
                            var queryy = FirebaseFirestore.instance
                                .collection('apps')
                                .where('title',
                                isGreaterThanOrEqualTo: value)
                                .snapshots();
                            query = queryy;
                          } else {
                            var queryy = FirebaseFirestore.instance
                                .collection('apps')
                                .snapshots();
                            query = queryy;
                          }
                          setState(() {});
                        },
                        controller: _searchController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                height: 42.h,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filterValue,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    iconSize: 24.h,
                    style: const TextStyle(color: Colors.black),
                    underline: null,
                    onChanged: (String? newValue) {
                      filterValue = newValue!;
                      if (newValue == 'Latest') {
                        var queryy = FirebaseFirestore.instance
                            .collection('apps')
                            .orderBy('uploadedAt', descending: true)
                            .snapshots();
                        query = queryy;
                      } else if (newValue == 'Older') {
                        var queryy = FirebaseFirestore.instance
                            .collection('apps')
                            .orderBy('uploadedAt')
                            .snapshots();
                        query = queryy;
                      } else if (newValue == 'Popularity') {
                        var queryy = FirebaseFirestore.instance
                            .collection('apps')
                            .orderBy('rating', descending: true)
                            .snapshots();
                        query = queryy;
                      } else {
                        var queryy = FirebaseFirestore.instance
                            .collection('apps')
                            .snapshots();
                        query = queryy;
                      }
                      setState(() {});
                    },
                    items: <String>[
                      'Filter By',
                      'Latest',
                      'Older',
                      'Popularity',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'Satoshi',
                            color: SchedulerBinding.instance.window
                                .platformBrightness ==
                                Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          CustomText(
            text: 'Suggested',
            size: 20.sp,
            fontWeight: FontWeight.w700,
            color: SchedulerBinding.instance.window.platformBrightness ==
                Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: query,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((document) {
                          return Padding(
                            padding:
                            const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: AppDisplayBox(
                              color: document['color'].toString(),
                              applicationTitle: document['title'],
                              category: document['category'],
                              backgroundColor: Color(int.parse("0xff" + document['color'])),
                              iconName: document['icon'],
                              appId: document.id,
                              description: document['description'],
                              ratting: document['rating'].toString(),
                              developer: document['developer'].toString(),
                              link: document['playStoreLink'],
                              downloads: document['downloads'].toString(),
                              reviewsList: document['reviews']
                            ),
                          );
                        }).toList()),
                  );
                } else
                  return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ));
              }),
        ],
      ),
    );
  }
}

class App {
    App({
    this.reviews,
    this.applicationTitle,
    this.category,
    this.iconName,
    this.appId,
    this.description,
    this.ratting,
    this.developer,
    this.link,
    this.publish,
    this.imagePath,
    this.color,
    this.downloads,
    this.reviewsList
  });
  String? color;
  String? imagePath;
  String? publish;
  String? applicationTitle;
  String? category;
  String? iconName;
  String? appId;
  String? description;
  String? ratting;
  String? developer;
  String? link;
  String? reviews;
  String? downloads;
  var reviewsList;  
}
