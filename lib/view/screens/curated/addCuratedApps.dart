import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sam_beckman/controller/usersController.dart';
import 'package:sam_beckman/view/screens/curated/curatedAppsView.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../apps_details_page.dart';
import 'package:string_extensions/string_extensions.dart';

class AddCuratedApps extends StatefulWidget {
  AddCuratedApps(
      {Key? key,
      required this.docId,
      required this.appsList,
      required this.appsIconsList,
      required this.urlList,
      required this.shelfName,
      required this.selectedColor,
      required this.addDialog,
      required this.updateDialog})
      : super(key: key);

  var docId;
  var appsList;
  var appsIconsList;
  var urlList;
  var shelfName;
  var selectedColor;
  var addDialog;
  var updateDialog;

  @override
  State<AddCuratedApps> createState() => _AddCuratedAppsState();
}

class _AddCuratedAppsState extends State<AddCuratedApps>{
      

  var currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('apps');

  List<String>? fav_list = [];
  TextEditingController _searchController = new TextEditingController();
  var query = FirebaseFirestore.instance.collection('apps').snapshots();

  @override
  Widget build(BuildContext context) {
    fav_list = [];

    print("Hereeeeeeeeeeeee" + widget.appsList.toString());

    var filterValue = "Filter By";

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            SchedulerBinding.instance.window.platformBrightness ==
                    Brightness.dark
                ? Color(0xff303030)
                : Color(0xfffbfbfb),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CuratedAppsView(
                      docId: widget.docId,
                      appsList: widget.appsList,
                      appsIconsList: widget.appsIconsList,
                      urlList: widget.urlList,
                      addDialog: widget.addDialog,
                      updateDialog: widget.updateDialog,
                      shelfName: widget.shelfName,
                      selectedColor: widget.selectedColor,
                    )));
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
              width: 180.w,
              child: TextButton(
                onPressed: null,
                child: Text(
                  'Add Apps',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        SchedulerBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 4,
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              )),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 10, 20),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Select ',
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(28),
                        color: SchedulerBinding
                                    .instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '                           ',
                      style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28),
                          color: Theme.of(context).primaryColor),
                    ),
                    TextSpan(
                      text: 'application ',
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
            SizedBox(
              height: 30.h,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: query,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((document) {
                            // var favColor = Colors.grey;

                            // if(fav_list!.contains(document['title'])){
                            //   favColor = Colors.red;
                            //   snapshots.data!.remove(document['title']);
                            // }

                            bool _selected = false;
                            if (widget.appsList
                                .contains(document.id.toString()))
                              _selected = true;

                            return GestureDetector(
                              onTap: () {
                                if (widget.appsList.contains(document.id)) {
                                  widget.appsList.remove(document.id);
                                  widget.appsIconsList.remove(document['icon']);
                                } else {
                                  widget.appsList.add(document.id);
                                  widget.appsIconsList
                                      .add(document['icon'].toString());
                                }
                                setState(() {});
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: AppDisplayBox(
                                  selectedIcon: _selected,
                                  imagePath: document['icon'],
                                  applicationTitle: document['title'],
                                  category: document['category'],
                                  // backgroundColor: Color(int.parse("0xff" + document['color'])),
                                  iconName: document['icon'],
                                  appId: document.id,
                                  // description: document['description'],
                                  // ratting: document['rating'].toString(),
                                  // developer: document['developer'].toString(),
                                  // link: document['playStoreLink'].toString(),
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  } else
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ));
                })
          ],
        ),
      ),
    );
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

class AppDisplayBox extends StatelessWidget {
  const AppDisplayBox(
      {Key? key,
      this.applicationTitle,
      this.imagePath,
      this.category,
      this.appId,
      this.ratting,
      this.developer,
      this.description,
      this.iconName,
      this.link,
      this.backgroundColor,
      this.color,
      this.selectedIcon})
      : super(key: key);

  final String? applicationTitle,
      iconName,
      appId,
      description,
      ratting,
      developer,
      link;
  final String? category;
  final String? imagePath;
  final Color? backgroundColor;
  final String? color;
  final bool? selectedIcon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
          color: SchedulerBinding.instance.window.platformBrightness ==
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
                image:
                    DecorationImage(image: NetworkImage(iconName.toString()))),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: applicationTitle,
                    size: 14.sp,
                    fontWeight: FontWeight.w700,
                    color:
                        SchedulerBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  CustomText(
                    text: category,
                    size: 12.sp,
                    fontWeight: FontWeight.w400,
                    color:
                        SchedulerBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ],
              ),
              selectedIcon!
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/icons/selectedIcon.png'))
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
