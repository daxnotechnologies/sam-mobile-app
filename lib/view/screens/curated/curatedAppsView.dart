// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, unused_import, must_be_immutable, prefer_typing_uninitialized_variables, prefer_const_constructors, unnecessary_new, prefer_final_fields

import 'dart:async';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sam_beckman/view/screens/curated/addCuratedApps.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';

import '../../../controller/usersController.dart';
import '../../widgets/bottom_navigation_bar.dart';

class CuratedAppsView extends StatefulWidget {
  CuratedAppsView(
      {Key? key,
      required this.docId,
      required this.appsList,
      required this.appsIconsList,
      required this.urlList,
      required this.addDialog,
      required this.updateDialog,
      required this.shelfName,    
      required this.selectedColor})
      : super(key: key);

  var appsList;
  var appsIconsList;
  bool addDialog;
  bool updateDialog;
  var shelfName;
  var urlList;
  var selectedColor;
  var docId;

  @override
  State<CuratedAppsView> createState() => _CuratedAppsViewState();
}

class _CuratedAppsViewState extends State<CuratedAppsView>
    with SingleTickerProviderStateMixin {
      

  var currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');

  TextEditingController _shelfNameController = new TextEditingController();
  TextEditingController _linkUrlController = new TextEditingController();

  var selectedColor = Color(0xffd25250);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _shelfNameController.text = widget.shelfName;
      selectedColor = widget.selectedColor;
      widget.addDialog ? getAddDialog() : null;
      widget.updateDialog ? getUpdateDialog() : null;
    });
  }

  var containerId = "";
  var _height = 300;

  var imagePath =
      "https://firebasestorage.googleapis.com/v0/b/sam-beckman.appspot.com/o/profile_images%2Fuser.png?alt=media&token=e7caad03-ed4d-48e7-b4c6-0e71ba0ae28a";

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
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
              width: 150.w,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 4,
                  shadowColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: getAddDialog,
                child: Text(
                  'Add New',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: SchedulerBinding
                                .instance.window.platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            body: FutureBuilder(
                future: userdata(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Your Application ',
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(28),
                                  color: SchedulerBinding.instance.window
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Shelves ',
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
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('curated')
                              .doc(currentUser!.uid)
                              .collection('curatedApps')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children:
                                    snapshot.data!.docs.map((document) {
                                  if (snapshot.hasData) {
                                    i++;
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if(containerId == document.id)
                                              containerId = "";
                                            else 
                                              containerId = document.id;
                                              WidgetsBinding.instance.addPostFrameCallback((_){
                                                // Add Your Code here. 
                                                setState(() {
                                                                                              
                                                });
                                              });
                                           
                                            // var appsList =
                                            //     await getCuratedApps(
                                            //         document.id);
                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) =>
                                            //             PostCuratedView(
                                            //               appIconsList:
                                            //                   document['appIcons'],
                                            //               appsList:
                                            //                   document['apps'],
                                            //               docId:
                                            //                   document.id,
                                            //             )));
                                          },
                                          child: Container(
                                            width: 300.w,
                                            height: containerId == document.id ? 300.h : 90.h,
                                            decoration: BoxDecoration(
                                                color: Color(int.parse(
                                                        '0xff${document['color']}'))
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            25))),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    SizedBox(
                                                      height: containerId == document.id ? 30 : 20,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              30, 0, 0, 0),
                                                      child: CustomText(
                                                          text: document[
                                                              'shelfName'],
                                                          size: 16.sp,
                                                          color: SchedulerBinding
                                                                      .instance
                                                                      .window
                                                                      .platformBrightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                    ),
                                                      Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              30, 0, 0, 0),
                                                      child: CustomText(
                                                          text: document['apps'].length.toString() + " Applications",
                                                          size: 14.sp,
                                                          color: SchedulerBinding
                                                                      .instance
                                                                      .window
                                                                      .platformBrightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          ),
                                                    ),
                        
                                                    containerId == document.id ? 
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 5,
                                                                crossAxisSpacing: 2,
                                                                mainAxisSpacing: 10),
                                                        itemCount: document['appIcons'].length,
                                                        itemBuilder: (BuildContext ctx, index) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(
                                                                top: 8, left: 8),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.grey
                                                                            .withOpacity(0.7),
                                                                        spreadRadius: 4,
                                                                        blurRadius: 7,
                                                                        offset: Offset(0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                    shape: BoxShape.circle,
                                                                    color: const Color.fromARGB(
                                                                        15, 55, 180, 78),
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(document['appIcons'][index])),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                        
                                                    ) : Container(),
                                                  ],
                                                ),
                                                containerId == document.id ? Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(bottom: 20),
                                                    child: Container(
                                                          decoration: BoxDecoration(
                                                          ),
                                                          width: 150.w,
                                                          child: TextButton(
                                                            style: TextButton.styleFrom(
                                                              padding: EdgeInsets.symmetric(vertical: 10.h),
                                                              backgroundColor: Colors.white,
                                                              elevation: 4,
                                                              shadowColor: Colors.black
                                                                          .withOpacity(0.7),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(15.r),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              widget.docId = document.id.toString();
                                                              widget.appsList = document['apps'];
                                                              widget.appsIconsList = document['appIcons'];
                                                              _shelfNameController.text = document['shelfName'];
                                                              widget.urlList = document['linkUrl'];
                                                              widget.selectedColor = document['color'];
                                                              getUpdateDialog();
                                                            },
                                                            child: Text(
                                                              'Edit List',
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                fontWeight: FontWeight.w500,
                                                                color: Colors.black
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  ),
                                                ) : Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        )
                                      ],
                                    );
                                  } else
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 60.h,
                                        ),
                                        Image.asset(
                                          'assets/images/smartphone.png',
                                          width: 200.w,
                                          height: 200.h,
                                        ),
                                        SizedBox(
                                          height: 35.h,
                                        ),
                                        CustomText(
                                          text:
                                              'Curate your own unique list of applications',
                                          size: 14.sp,
                                          color: SchedulerBinding
                                                      .instance
                                                      .window
                                                      .platformBrightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        SizedBox(
                                          height: 70.h,
                                        ),
                                      ],
                                    );
                                }).toList());
                            } else
                              return Container();
                          }),
                    ],
                  );
                })));
  }
  
  updateList() async {
    var collection = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    dev.log(widget.docId.toString());

    await collection.doc(widget.docId).update(
        {
        "apps": widget.appsList, 
        "appIcons" : widget.appsIconsList, 
        "linkUrl": widget.urlList,
        "shelfName" : _shelfNameController.text,
        "color" : selectedColor.toString().substring(10, 16),
        }).whenComplete(() => Navigator.pop(context));
  }

  addList() async {
    var collectionCurated = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    final json = {
      "color": selectedColor.toString().substring(10, 16),
      "linkUrl": widget.urlList,
      "shelfName": _shelfNameController.text,
      "apps": widget.appsList,
      "appIcons" : widget.appsIconsList
    };

    await collectionCurated.add(json);
    Navigator.pop(context);
  }

  userdata() async {
    var user = await collectionReference.doc(currentUser!.uid).get();
    imagePath = user['imagePath'].toString();
    return user['imagePath'].toString();
  }

  getAddDialog() {
    List<Color> _colorsList = [
      Color(0xffd25250),
      Color(0xfff4ad89),
      Color(0xfffff6a6),
      Color(0xffacd2a0),
      Color(0xff84cff0),
      Color(0xff8685b5),
      Color(0xffea9ba0)
    ];

    return showDialog(
        context: context,
        builder: (ctx) => Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Shelf Name',
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              color: Colors.transparent,
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  child: TextFormField(
                                    controller: _shelfNameController,
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      color: Color(0xffa3a3a3),
                                      fontSize: 12.sp,
                                    ),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        border: InputBorder.none,
                                        hintText: "i.e \"Customization\"",
                                        hintStyle: TextStyle(
                                          fontFamily: 'Satoshi',
                                          color: Color(0xffa3a3a3),
                                          fontSize: 12.sp,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'Select Apps',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          2, 6), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 40,
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AddCuratedApps(
                                                docId: widget.docId,
                                                appsList: widget.appsList,
                                                appsIconsList:
                                                    widget.appsIconsList,
                                                urlList: widget.urlList,
                                                shelfName:
                                                    _shelfNameController.text,
                                                selectedColor: selectedColor,
                                                addDialog: true,
                                                updateDialog: false,)));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 10),
                                    itemCount: widget.appsIconsList.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                    spreadRadius: 4,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(
                                                    15, 55, 180, 78),
                                                image: DecorationImage(
                                                    image: NetworkImage(widget
                                                        .appsIconsList[index])),
                                              ),
                                            ),
                                            Container(
                                                height: 43,
                                                width: 43,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent),
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        widget.appsList
                                                            .removeAt(index);
                                                        widget.appsIconsList
                                                            .removeAt(index);
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        CuratedAppsView(
                                                                          docId: widget.docId,
                                                                          appsList:
                                                                              widget.appsList,
                                                                          appsIconsList:
                                                                              widget.appsIconsList,
                                                                          urlList: widget.urlList,
                                                                          addDialog:
                                                                              true,
                                                                          updateDialog: false,
                                                                          shelfName:
                                                                              _shelfNameController.text,
                                                                          selectedColor:
                                                                              selectedColor,
                                                                        )));
                                                      },
                                                      child: Container(
                                                          height: 12.h,
                                                          width: 12.w,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  0xfff3f3f3)),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 9.sp,
                                                            color: Colors.black,
                                                          )),
                                                    ))),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            // GestureDetector(
                            //   onTap: showUrlDialog,
                            //   child: Material(
                            //     color: Colors.transparent,
                            //     child: Text(
                            //       'Custom Application? \nTap to enter it\'s URL:',
                            //       style: TextStyle(
                            //           fontFamily: 'Satoshi',
                            //           fontSize: 11.sp,
                            //           color: Theme.of(context).primaryColor,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'List Colour',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 0, 10.w, 0),
                              child: Container(
                                height: 50.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _colorsList.length,
                                  itemBuilder: (context, index) {
                                    print("colorrrrrrrrrrrrrrrrrrrr");
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            selectedColor = _colorsList[index];
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CuratedAppsView(
                                                          docId: widget.docId,
                                                          appsList:
                                                              widget.appsList,
                                                          appsIconsList: widget
                                                              .appsIconsList,
                                                          urlList: widget.urlList,
                                                          addDialog: true,
                                                          updateDialog: false,
                                                          shelfName:
                                                              _shelfNameController
                                                                  .text,
                                                          selectedColor:
                                                              selectedColor,
                                                        )));
                                          },
                                          child: Container(
                                            width: 25.0,
                                            height: 25.0,
                                            decoration: new BoxDecoration(
                                              border: selectedColor ==
                                                      _colorsList[index]
                                                  ? Border.all(
                                                      color: Colors.black)
                                                  : Border.all(
                                                      color:
                                                          Colors.transparent),
                                              color: _colorsList[index],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 8), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 130.w,
                                child: TextButton(
                                  onPressed: addList,
                                  child: Text(
                                    'Create List',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: SchedulerBinding.instance.window
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 30.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(imagePath))),
                  ),
                ],
              ),
            )));
  }

  showUrlDialog() {
    return showDialog(
        context: context,
        builder: (ctx) => Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        'Application URL',
                                        style: TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontSize: 11.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        "*",
                                        style: TextStyle(
                                            fontFamily: 'Satoshi',
                                            fontSize: 11.sp,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  height: 50,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20.r),
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      child: TextFormField(
                                        controller: _linkUrlController,
                                        style: TextStyle(
                                          fontFamily: 'Satoshi',
                                          color: Color(0xffa3a3a3),
                                          fontSize: 12.sp,
                                        ),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            onPressed: (){
                                              widget.urlList.add(_linkUrlController.text);
                                              _linkUrlController.text = "";
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.send, color: Color(0xffacc6d1),)),
                                            fillColor: Colors.white,
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Paste URL here",
                                            hintStyle: TextStyle(
                                              fontFamily: 'Satoshi',
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: ListView.separated(
                                    itemCount: widget.urlList.length,
                                    itemBuilder: ((context, index) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          widget.urlList.elementAt(index).toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: 'Satoshi',
                                              fontSize: 11.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 3,
                                        ),
                                      );
                                    }),
                                    separatorBuilder: (context, index){
                                      return Divider(height: 20,);
                                    },
                                  ),
                                ),
                              ],
                            ),
                             Padding(
                               padding: const EdgeInsets.only(bottom: 15),
                               child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.35),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(
                                            0, 8), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  width: 130.w,
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: SchedulerBinding.instance.window
                                                    .platformBrightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      elevation: 4,
                                      shadowColor: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                    ),
                                  )),
                             ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(imagePath))),
                  ),
                ],
              ),
            )));
  }

  getUpdateDialog() {
    // var appIconsList, var appsList, var shelfName
    List<Color> _colorsList = [
      Color(0xffd25250),
      Color(0xfff4ad89),
      Color(0xfffff6a6),
      Color(0xffacd2a0),
      Color(0xff84cff0),
      Color(0xff8685b5),
      Color(0xffea9ba0)
    ];

    return showDialog(
        context: context,
        builder: (ctx) => Center(
                child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Shelf Name',
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    "*",
                                    style: TextStyle(
                                        fontFamily: 'Satoshi',
                                        fontSize: 11.sp,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              color: Colors.transparent,
                              child: Center(
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  child: TextFormField(
                                    controller: _shelfNameController,
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
                                      color: Color(0xffa3a3a3),
                                      fontSize: 12.sp,
                                    ),
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        border: InputBorder.none,
                                        hintText: "i.e \"Customization\"",
                                        hintStyle: TextStyle(
                                          fontFamily: 'Satoshi',
                                          color: Color(0xffa3a3a3),
                                          fontSize: 12.sp,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'Select Apps',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          2, 6), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 40,
                                height: 40,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AddCuratedApps(
                                                docId: widget.docId,
                                                appsList: widget.appsList,
                                                appsIconsList:
                                                    widget.appsIconsList,
                                                urlList: widget.urlList,
                                                shelfName:
                                                    _shelfNameController.text,
                                                selectedColor: selectedColor,
                                                addDialog: false,
                                                updateDialog: true,)));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 2,
                                            mainAxisSpacing: 10),
                                    itemCount: widget.appsIconsList.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 8),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.7),
                                                    spreadRadius: 4,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                                shape: BoxShape.circle,
                                                color: const Color.fromARGB(
                                                    15, 55, 180, 78),
                                                image: DecorationImage(
                                                    image: NetworkImage(widget
                                                        .appsIconsList[index])),
                                              ),
                                            ),
                                            Container(
                                                height: 43,
                                                width: 43,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.transparent),
                                                child: Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        widget.appsList
                                                            .removeAt(index);
                                                        widget.appsIconsList
                                                            .removeAt(index);
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        CuratedAppsView(
                                                                          docId: widget.docId,
                                                                          appsList:
                                                                              widget.appsList,
                                                                          appsIconsList:
                                                                              widget.appsIconsList,
                                                                          urlList: widget.urlList,
                                                                          addDialog:
                                                                              false,
                                                                          updateDialog:
                                                                              true,
                                                                          shelfName:
                                                                              _shelfNameController.text,
                                                                          selectedColor:
                                                                              selectedColor,
                                                                        )));
                                                      },
                                                      child: Container(
                                                          height: 12.h,
                                                          width: 12.w,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                  0xfff3f3f3)),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 9.sp,
                                                            color: Colors.black,
                                                          )),
                                                    ))),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            // GestureDetector(
                            //   onTap: showUrlDialog,
                            //   child: Material(
                            //     color: Colors.transparent,
                            //     child: Text(
                            //       'Custom Application? \nTap to enter it\'s URL:',
                            //       style: TextStyle(
                            //           fontFamily: 'Satoshi',
                            //           fontSize: 11.sp,
                            //           color: Theme.of(context).primaryColor,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Text(
                                'List Colour',
                                style: TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 11.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 0, 10.w, 0),
                              child: Container(
                                height: 50.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _colorsList.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            selectedColor = _colorsList[index];
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        CuratedAppsView(  
                                                          docId: widget.docId,
                                                          appsList:
                                                              widget.appsList,
                                                          appsIconsList: widget
                                                              .appsIconsList,
                                                          urlList: widget.urlList,
                                                          addDialog: false,
                                                          updateDialog: true,
                                                          shelfName:
                                                              _shelfNameController
                                                                  .text,
                                                          selectedColor:
                                                              selectedColor,
                                                        )));
                                          },
                                          child: Container(
                                            width: 25.0,
                                            height: 25.0,
                                            decoration: new BoxDecoration(
                                              border: selectedColor ==
                                                      _colorsList[index]
                                                  ? Border.all(
                                                      color: Colors.black)
                                                  : Border.all(
                                                      color:
                                                          Colors.transparent),
                                              color: _colorsList[index],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                 Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.35),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(
                                          0, 8), // changes position of shadow
                                    ),
                                  ],
                                ),
                                width: 120.w,
                                child: TextButton(
                                  onPressed: updateList,
                                  child: Text(
                                    'Update List',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: SchedulerBinding.instance.window
                                                  .platformBrightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                )),
                                Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.35),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: Offset(
                                              0, 8), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    width: 120.w,
                                    child: TextButton(
                                      onPressed: () async{
                                        var doc = FirebaseFirestore.instance
                                        .collection('curated')
                                        .doc(currentUser!.uid)
                                        .collection('curatedApps').doc(widget.docId);

                                        await doc.delete();
                                        Navigator.pop(context);

                                        setState(() {
                                          
                                        });
                                      },
                                      child: Text(
                                        'Delete List',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: SchedulerBinding.instance.window
                                                      .platformBrightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10.h),
                                        backgroundColor:Color(0xffd74f51),
                                        elevation: 4,
                                        shadowColor: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(imagePath))),
                  ),
                ],
              ),
            )));
  }
  

  
  Future<List<String>> getCuratedApps(docUid) async {
    List<String> appsList = <String>[];
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('curated')
        .doc(currentUser!.uid)
        .collection('curatedApps');

    var Mapapps = await collection.doc(docUid).get();
    List Listapps = [];
    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['apps'];
    appsList.isEmpty
        ? Listapps.forEach((element) {
            appsList.add(element.toString());
          })
        : null;
    print(appsList.toList().toString());
    return appsList;
  }
}

// class CuratedAppsViewBody extends StatefulWidget {
//   CuratedAppsViewBody({Key? key, required this.appsList, required this.appsIconsList, required this.dialog, required this.shelfName, required this.linkUrl, required this.selectedColor}) : super(key: key);

//   var appsList;
//   var appsIconsList;
//   bool dialog;
//   var shelfName;
//   var linkUrl;
//   var selectedColor;

//               // floatingActionButton: Container(
//               //   decoration: BoxDecoration(
//               //       boxShadow: [
//               //       BoxShadow(
//               //         color: Theme.of(context).primaryColor.withOpacity(0.35),
//               //         spreadRadius: 1,
//               //         blurRadius: 15,
//               //         offset: Offset(0, 8), // changes position of shadow
//               //       ),
//               //     ],
//               //   ),
//               //   width: 150.w,
//               //   child: TextButton(
//               //     style: TextButton.styleFrom(
//               //       padding: EdgeInsets.symmetric(vertical: 14.h),
//               //       backgroundColor: Theme.of(context).primaryColor,
//               //       elevation: 4,
//               //       shadowColor: Theme.of(context).primaryColor,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(20.r),
//               //       ),
//               //     ),
//               //     onPressed: getDialog,
//               //     child: Text(
//               //       'Add New',
//               //       style: TextStyle(
//               //         fontSize: 16.sp,
//               //         fontWeight: FontWeight.w500,
//               //         color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
//               //         ? Colors.white
//               //         : Colors.black,
//               //       ),
//               //     ),
//               //   ),
//               // ),

//   @override
//   State<CuratedAppsViewBody> createState() => _CuratedAppsViewBodyState();
// }

// class _CuratedAppsViewBodyState extends State<CuratedAppsViewBody> {
//   var currentUser = FirebaseAuth.instance.currentUser;

//   CollectionReference collectionReference =
//       FirebaseFirestore.instance.collection('users');


//   TextEditingController _shelfNameController = new TextEditingController();
//   TextEditingController _linkUrlController = new TextEditingController();
//   var selectedColor = Color(0xffd25250);


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       _shelfNameController.text = widget.shelfName;
//       _linkUrlController.text = widget.linkUrl;
//       selectedColor = widget.selectedColor;
//       widget.dialog ? getDialog() : null;
//    });

//   }

//   var imagePath = "https://firebasestorage.googleapis.com/v0/b/sam-beckman.appspot.com/o/profile_images%2Fuser.png?alt=media&token=e7caad03-ed4d-48e7-b4c6-0e71ba0ae28a";


//   @override
//   Widget build(BuildContext context) {
//     int i = 0;

//     return
//   }


// }