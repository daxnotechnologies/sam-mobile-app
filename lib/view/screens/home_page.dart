import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sam_beckman/controller/apiService.dart';
import 'package:sam_beckman/controller/firebaseAuthController.dart';
import 'package:sam_beckman/controller/homeController.dart';
import 'package:sam_beckman/model/chanel_models.dart';
import 'package:sam_beckman/model/video_models.dart';
import 'package:sam_beckman/view/constants.dart';
import 'package:sam_beckman/view/screens/apps_details_page.dart';
import 'package:sam_beckman/view/screens/login_page.dart';
import 'package:sam_beckman/view/screens/search_page.dart';
import 'package:sam_beckman/view/screens/showCategoryApps.dart';
import 'package:sam_beckman/view/screens/user_profile_page.dart';
import 'package:sam_beckman/view/screens/videos_page.dart';
import 'package:sam_beckman/view/widgets/bottom_navigation_bar.dart';
import 'package:sam_beckman/view/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../controller/favController.dart';
import '../../controller/usersController.dart';
import '../../model/popup_model.dart';
import '../widgets/categories/category_container.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;
  usersController users = new usersController();

  String? wish;
  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    offsetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(1.5, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));

    getVideos();
    log("asdddddddddddddddddddddasddd");
    super.initState();

    Timer.periodic(Duration(seconds: 2), (timer) async {
      _controller.reset();
    });
  }

  getVideos() async {
    users.videos = APIService.instance.fetchVideosFromPlaylist(
        playlistId: "PLRpUhZJr8rJ0W8tejKGBhew6J2PxTW3p3");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => Scaffold(
          bottomNavigationBar: SlideTransition(
              position: offsetAnimation, child: CustomBottomNavigationBar(0)),
          body: Stack(
            fit: StackFit.expand,
            children: [
              HomePageBody(),
              DraggableScrollableSheet(
                initialChildSize: 0.12,
                minChildSize: 0.12,
                maxChildSize: 0.9,
                builder: ((context, scrollController) =>
                    VideosPage(controller: scrollController, videos: users.videos)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageBody extends StatefulWidget {
  HomePageBody({Key? key}) : super(key: key);

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody>
    with SingleTickerProviderStateMixin {
  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference collectionReference1 =
      FirebaseFirestore.instance.collection('users');
  String name = '';
  AnimationController? _animationController;
  var auth = FirebaseAuth.instance;

  String? image;
  var appIdsList = [];

  @override
  void initState() {
    // TODO: implement initStat
    controller.appList.clear();
    controller.category.value = '';
    controller.catagoryAppList.clear();
    userdata();
    getName();
    super.initState();
    
  }
  userdata() async {
    var userData = await collectionReference1.doc(auth.currentUser!.uid).get();
    name = userData['name'];
    image = userData['imagePath'];
    await controller.Getapps();
    await getFavourites();
  }

  getFavourites() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('favourites');

    var Mapapp = await collectionReference.doc(auth.currentUser!.uid).get();
    if (Mapapp != null) {
      await collectionReference
          .doc(auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          var appsList = (snapshot.data() as Map<String, dynamic>)['appList'];
          for (int i = 0; i < appsList.length; i++) {
            appIdsList.add(appsList[i]['appId'].toString());
          }
        }
      });
    }

    // List Listapps = [];
    // Mapapps.data() == null ? null : Listapps = Mapapps.data()!['appList'];
  }

  homeController controller = Get.put(homeController());
  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        builder: () => Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async{
                          if(currentUser!.email == "guest@gmail.com"){
                            var value = await popup(context, "Sign in to favourite, \ncurate and review apps.", "Sign in", "No thanks");
                            if(value){
                              Navigator.pop(context);
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login()));
                            } else 
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (_) => const UserProfilePage()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const UserProfilePage()));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  image.toString()))
                                          : DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/profile.png'))),
                                ),
                                SizedBox(width: 12.h),
                                CustomText(
                                  text: '$name!',
                                  size: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: SchedulerBinding.instance.window
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ],
                            ),
                            currentUser!.email == "guest@gmail.com" ? Container() : IconButton(
                                onPressed: () async {
                                  // var authentication = FirebaseAuth.instance;
                                  // print(authentication.currentUser);

                                  // await authentication.signOut();

                                  // print("After Logout" + authentication.currentUser.toString());
                                 
                                  var value = await popup(context,
                                  "Are you sure you want to logout?",
                                  "Yep! log me out.",
                                  "Nope! just kidding."
                                  );

                                  if (value) {
                                    // Navigator.pop(context);
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    firebaseAuthController auth =
                                        new firebaseAuthController();
                                    auth.signOut().then((value) => {
                                          pref.setBool('logined', false),
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login())),
                                        });
                                  }

                                  // SharedPreferences pref =
                                  //     await SharedPreferences.getInstance();
                                  // firebaseAuthController auth =
                                  //     new firebaseAuthController();
                                  // auth.signOut().then((value) => {
                                  //  GoogleSignIn().signOut(),
                                  //       pref.setBool('logined', false),
                                  //       Navigator.of(context).pushReplacement(
                                  //           MaterialPageRoute(
                                  //               builder: (context) => Login())),
                                  //     });
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: SchedulerBinding.instance.window
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomText(
                        text: DateTime.now().hour >= 6 &&
                                DateTime.now().hour <= 12
                            ? 'Good Morning!'
                            : DateTime.now().hour >= 12 &&
                                    DateTime.now().hour <= 20
                                ? 'Good Evening!'
                                : "Good Night!",
                        size: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: SchedulerBinding
                                    .instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 38.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Category',
                            size: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: SchedulerBinding
                                        .instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return FractionallySizedBox(
                                        heightFactor: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(20.h),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style:
                                                    OutlinedButton.styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0.r),
                                                  side: const BorderSide(
                                                      color: Colors.grey),
                                                )),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_back_ios,
                                                      color: SchedulerBinding
                                                                  .instance
                                                                  .window
                                                                  .platformBrightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    CustomText(
                                                      text: 'Back',
                                                      size: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                              SizedBox(height: 24.h),
                                              CustomText(
                                                text: 'Choose Your',
                                                size: 28.sp,
                                                fontWeight: FontWeight.w700,
                                                color: SchedulerBinding
                                                            .instance
                                                            .window
                                                            .platformBrightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              CustomText(
                                                  text: 'Category',
                                                  size: 28.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              SizedBox(height: 14.h),
                                              DropdownButton<String>(
                                                value: 'Filter By',
                                                icon: const Icon(Icons
                                                    .keyboard_arrow_down),
                                                iconSize: 24.h,
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: 'Satoshi',
                                                  color: SchedulerBinding
                                                              .instance
                                                              .window
                                                              .platformBrightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                underline: null,
                                                onChanged:
                                                    (String? newValue) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              SearchPage(
                                                                filterValue: newValue ==
                                                                        null
                                                                    ? 'Filter By'
                                                                    : newValue,
                                                              )));
                                                },
                                                items: <String>[
                                                  'Filter By',
                                                  'Latest',
                                                  'Older',
                                                  'Popularity',
                                                ].map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                              SizedBox(height: 24.h),
                                              StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('categories')
                                                      .orderBy('name')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    int i = 0;
                                                    if (snapshot.hasData) {
                                                      i++;
                                                      return Expanded(
                                                        child: GridView(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.h),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    1.0,
                                                                mainAxisExtent:
                                                                    MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height /
                                                                        6,
                                                                crossAxisCount: 2,
                                                                crossAxisSpacing:
                                                                    12.h,
                                                                mainAxisSpacing:
                                                                    12.h),
                                                              children: snapshot.data!.docs.map((document) {
                                                                return InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(context);
                                                                  Navigator.of(context).push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ShowCategories(
                                                                                categoryValue:
                                                                                    document['name'])));
                                                                },
                                                                child:
                                                                    CategoriesBox(
                                                                    title: document['name'],
                                                                    imagePath:
                                                                      kCategoriesImagesNames[
                                                                          i],
                                                                                                                                    ),
                                                              );
                                                            }).toList()

                                                          ),
                                                      );
                                                    } else
                                                      return Container();
                                                  }),
                                            ],
                                          ),
                                        ));
                                  });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => const Categories()));
                            },
                            child: CustomText(
                                text: 'See all',
                                size: 12.sp,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: SizedBox(
                          height: 70.h,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('categories')
                                  .orderBy('name')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                int i = 0;
                                if (snapshot.hasData) {
                                  return ListView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children:
                                          snapshot.data!.docs.map((document) {
                                        if (i == 0) {
                                          i++;
                                          return CategoryContainer(
                                            color:
                                                Theme.of(context).primaryColor,
                                            title: "All",
                                            shadow: true,
                                            iconPath: kCategoriesImagesNames[i],
                                          );
                                        } else {
                                          i++;
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowCategories(
                                                              categoryValue:
                                                                  '${document['name']}')));
                                            },
                                            child: CategoryContainer(
                                              shadow: false,
                                              color: Colors.grey.shade300,
                                              title: document['name'],
                                              iconPath:
                                                  kCategoriesImagesNames[i],
                                            ),
                                          );
                                        }
                                      }).toList());
                                } else
                                  return Container();
                              })),
                    ),
                    SizedBox(height: 28.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomText(
                        text: 'Recent Applications',
                        size: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: SchedulerBinding
                                    .instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                            child: FutureBuilder(
                                future: Future.delayed(Duration(seconds: 2)),
                                builder: (context, snap) {
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.appList.length,
                                      itemBuilder: (context, index) {
                                        String? appId = controller.appList
                                            .elementAt(index)
                                            .appId;
                                        bool app = false;
                                        for (int i = 0;
                                            i < appIdsList.length;
                                            i++) {
                                          if (appId == appIdsList[i]) {
                                            app = true;
                                            break;
                                          }
                                        }
                                        return ApplicationContainer(
                                          favColor: app
                                              ? Colors.red
                                              : Colors.grey[400],
                                          color: controller.appList
                                              .elementAt(index)
                                              .color,
                                          applicationTitle: controller.appList
                                              .elementAt(index)
                                              .applicationTitle,
                                          category: controller.appList
                                              .elementAt(index)
                                              .category,
                                          backgroundColor: Color(int.parse(
                                              '0xff${controller.appList.elementAt(index).color}')),
                                          iconName: controller.appList
                                              .elementAt(index)
                                              .iconName,
                                          appId: controller.appList
                                              .elementAt(index)
                                              .appId,
                                          description: controller.appList
                                              .elementAt(index)
                                              .description,
                                          ratting: controller.appList
                                              .elementAt(index)
                                              .ratting
                                              .toString(),
                                          developer: controller.appList
                                              .elementAt(index)
                                              .developer
                                              .toString(),
                                          link: controller.appList
                                              .elementAt(index)
                                              .link
                                              .toString(),
                                          reviewsList: controller.appList
                                              .elementAt(index)
                                              .reviewsList,
                                          downloads: controller.appList
                                              .elementAt(index)
                                              .downloads
                                              .toString(),
                                        );
                                      });
                                }),
                          ),

                    SizedBox(
                      height: 90.h,
                    ),
                  ],
                ),
              ),
            ));
  }

  getName() async {
    var temp = await collectionReference1.doc(currentUser!.uid).get();

    setState(() {
      name = temp['name'];
    });
  }
}

class CategoryContainer extends StatelessWidget {
  CategoryContainer(
      {Key? key, this.title, this.iconPath, this.color, this.shadow})
      : super(key: key);
  bool? shadow;
  final String? title;
  final String? iconPath;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, right: 14.w, bottom: 12.h),
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        boxShadow: [
          shadow!
              ? BoxShadow(
                  color: Color.fromARGB(100, 254, 192, 42),
                  spreadRadius: 1,
                  blurRadius: 15,
                )
              : BoxShadow(
                  color: Colors.transparent, spreadRadius: 1, blurRadius: 10)
        ],
        borderRadius: BorderRadius.circular(15.r),
        color: color ?? Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/categories/$iconPath.png',
            width: 28.w,
            height: 28.h,
            color: Colors.white,
          ),
          CustomText(
            text: title ?? '',
            size: 12.sp,
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

class ApplicationContainer extends StatefulWidget {
  ApplicationContainer(
      {Key? key,
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
      this.downloads})
      : super(key: key);
  final String? color;
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
  Color? favColor;
  var reviewsList;
  final String? downloads;

  @override
  State<ApplicationContainer> createState() => _ApplicationContainerState();
}

class _ApplicationContainerState extends State<ApplicationContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AppsDetailsPage(
                    favColor: widget.favColor,
                    color: widget.color,
                    link: widget.link,
                    developer: this.widget.developer,
                    description: widget.description,
                    appId: widget.appId,
                    applicationTitle: widget.applicationTitle,
                    category: widget.category,
                    iconName: widget.iconName,
                    ratting: widget.ratting,
                    reviewsList: widget.reviewsList,
                    downloads: widget.downloads))).then((value) => {
                      setState(() {
                        
                      })
                    });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 10)
          ],
          color: SchedulerBinding.instance.window.platformBrightness !=
                  Brightness.dark
              ? widget.backgroundColor
              : Colors.grey.shade700.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                color: SchedulerBinding.instance.window.platformBrightness ==
                        Brightness.dark
                    ? Colors.black38
                    : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        foregroundImage: NetworkImage(widget.iconName!),
                      ),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                text: widget.applicationTitle ?? '',
                                size: 18.sp,
                                color: SchedulerBinding.instance.window
                                            .platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
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
                          text: 'App Rating',
                          size: 12.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                      SizedBox(width: 12.w),
                      CustomText(
                          text: '${widget.reviewsList.length.toString()} Reviews',
                          size: 12.sp,
                          color: SchedulerBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    text: 'Category: ${widget.category}',
                    size: 12.sp,
                    color: Colors.white),
                InkWell(
                  highlightColor: Colors.red,
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser!.email !=
                        'guest@gmail.com')
                      widget.favColor == Colors.grey[400]
                          ? widget.favColor = Colors.red
                          : widget.favColor = Colors.grey[400];
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
                        'reviews' : widget.reviewsList,
                        'downloads' : widget.downloads
                      }, context);
                      setState(() {
                        
                      });
                      
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12.r,
                      child: Icon(
                        Icons.favorite,
                        color: widget.favColor,
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
