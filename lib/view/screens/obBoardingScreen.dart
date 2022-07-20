import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_page.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({Key, key}) : super(key: key);

  @override
  _onBoardingState createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  int?index;
  PageController controller=new PageController();

  initializeState() async{
    var pref=await SharedPreferences.getInstance();
    pref.setString('onBoard', "Hello");
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeState();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 812),
      builder: () => SafeArea(child:Scaffold(
      body:Container(
        color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                  Color(0xff303030):
                  Colors.white,
        child: Column(
          children: [
            Container(
              color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
              Color(0xff303030):
              Colors.white
              ,
              height:MediaQuery.of(context).size.height*0.80,
              child: PageView(

                onPageChanged: (indexes){
                  print(indexes);
                  setState(() {
                    index=indexes;
                  });
                },
                controller: controller,
                children: [
                  firstPage(),
                  seccondPage(),
                  thirdPage()
                ],
              ),
            ),

            SizedBox(height: 20.h,),

           
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SmoothPageIndicator(
        //             controller: controller,  // PageController
        //             count:3,
        //             // forcing the indicator to use a specific direction
        //             textDirection: TextDirection.ltr,
        //             effect:  SwapEffect(type:SwapType.yRotation,dotColor: Colors.grey,activeDotColor:Theme.of(context).primaryColor,dotHeight:15,dotWidth:15),
        // ),

        //       ],
        //     ),
        //   ),
            InkWell(
              onTap: ()=>Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              ),
              child: Container(
                  height:60,
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    
                    border: Border.all(color:Color(0xfffec12b),width: 2),
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text('Start now!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Satoshi'
                      ),
                    ),
                  )
              ),
            )
        ],
        ),
      )
    )));
  }
}
class firstPage extends StatefulWidget {
  const firstPage({Key,key}) : super(key: key);

  @override
  _firstPageState createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipPath(
            clipper:CurveImage(),
            child: Container(
              width: double.infinity,
              height: 340.h,
              decoration: BoxDecoration(
                color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                  Color(0xff303030):
                  Color(0xfff7f7f7),
                image: DecorationImage(image:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ?  
                AssetImage('assets/gifs/gif1_dark.gif') :
                AssetImage('assets/gifs/gif1_light.gif')),
              )
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 40.h),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:'Explore. ',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color:MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Discover.',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                'Browse new and exciting applications added to the app every single week.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey, fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.fromLTRB(120, 50, 120, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Color(0xfff7bb2c), width: 4),
                  shape: BoxShape.circle
                ),
                child: Text(""),
                            ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),

              

              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),
            ],),
          ),
        ],
      ),
    );
  }
}

class seccondPage extends StatefulWidget {
  const seccondPage({Key,key}) : super(key: key);

  @override
  _secondPageState createState() => _secondPageState();
}

class _secondPageState extends State<seccondPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipPath(
            clipper: CurveImage(),
            child: Container(
              width: double.infinity,
              height: 340.h,
              decoration: BoxDecoration(
                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                  Color(0xff303030):
                  Color(0xfff7f7f7),
                  image: DecorationImage(image:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ?  
              AssetImage('assets/gifs/gif2_dark.gif') :
              AssetImage('assets/gifs/gif2_light.gif')),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 40.h),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:'Watch. ',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color:MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Learn.',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                "Like an application you’ve discovered? Watch the video it was featured in on YouTube.",                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey, fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(120, 50, 120, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),

              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Color(0xfff7bb2c), width: 4),
                  shape: BoxShape.circle
                ),
                child: Text(""),
              ),

              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),
            ],),
          ),
        ],
      ),
    );
  }
}
class thirdPage extends StatefulWidget {
  const thirdPage({Key,key}) : super(key: key);

  @override
  _thirdPageState createState() => _thirdPageState();
}

class _thirdPageState extends State<thirdPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipPath(
            clipper: CurveImage(),
            child: Container(
              width: double.infinity,
              height: 330.h,
              decoration: BoxDecoration(
                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                  Color(0xff303030):
                  Color(0xfff7f7f7),
                  image: DecorationImage(image:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ?  
              AssetImage('assets/gifs/gif3_dark.gif') :
              AssetImage('assets/gifs/gif3_light.gif')),
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 40.h),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text:'Curate. ',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color:MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Rate.',
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                "Create your very own lists of applications and provide your own ratings and reviews of each app!",                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey, fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(120, 20, 120, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),


              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xffebebeb).withOpacity(0.8),
                  shape: BoxShape.circle
                ),
              ),

              
              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Color(0xfff7bb2c), width: 4),
                  shape: BoxShape.circle
                ),
                child: Text(""),
              ),
            ],),
          ),





          // ClipPath(
          //   clipper: CurveImage(),
          //   child: Container(
          //     width: double.infinity,
          //     height: 350.h,
          //     decoration: BoxDecoration(
          //         color: Colors.transparent,
          //         image: DecorationImage(image:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ?  
          //     AssetImage('assets/gifs/gif3_dark.gif') :
          //     AssetImage('assets/gifs/gif3_light.gif')),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     margin: EdgeInsets.only(top: 40.h),
          //     child: RichText(
          //       text: TextSpan(children: [
          //         TextSpan(
          //           text:'Curate. ',
          //           style:TextStyle(
          //             fontSize: 28.sp,
          //             fontWeight: FontWeight.bold,
          //             color:MediaQuery.of(context).platformBrightness ==
          //                 Brightness.dark
          //                 ? Colors.white
          //                 : Colors.black,
          //           ),
          //         ),
          //         TextSpan(
          //           text: 'Rate.',
          //           style: TextStyle(
          //             fontSize: 28.sp,
          //             color: Theme.of(context).primaryColor,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         )
          //       ]),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     margin: EdgeInsets.only(top: 30.h),
          //     child: Text(
          //         'Create your very own lists of applications and provide your own ratings and reviews of each app!',
          //       style: TextStyle(
          //           color: Colors.grey, fontSize: 17.sp, fontWeight: FontWeight.w500),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(120, 0, 120, 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //     Container(
          //       width: 10,
          //       height: 10,
          //       decoration: BoxDecoration(
          //         color: Color(0xffebebeb).withOpacity(0.8),
          //         shape: BoxShape.circle
          //       ),
          //     ),

          //     Container(
          //       width: 10,
          //       height: 10,
          //       decoration: BoxDecoration(
          //         color: Color(0xffebebeb).withOpacity(0.8),
          //         shape: BoxShape.circle
          //       ),
          //     ),
          //      Container(
          //       width: 17,
          //       height: 17,
          //       decoration: BoxDecoration(
          //         color: Colors.transparent,
          //         border: Border.all(color: Color(0xfff7bb2c), width: 4),
          //         shape: BoxShape.circle
          //       ),
          //       child: Text(""),
          //     ),
          //   ],),
          // ),
        ],
      ),
    );
  }
}
class CurveImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height,
        size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}