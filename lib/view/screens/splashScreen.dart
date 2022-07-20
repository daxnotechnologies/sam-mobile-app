import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/login_page.dart';
import 'package:sam_beckman/view/screens/obBoardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key,key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  var logined;

  var onBoard;
  void initService() async{
    var pref=await SharedPreferences.getInstance();
    onBoard = pref.getString('onBoard');
    if(pref.getBool('logined')!=null){
      if(pref.getBool('logined') == true){
        logined=true;
      }else{
       logined=false;
      }
    }
    else{
     logined=false;
    }
  }

  @override
  void initState() {
    initService();
    Future.delayed(Duration(seconds:1)).then((value) =>
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> onBoard == null ? onBoarding() : logined==false || logined==null? Login():Home()))
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 812),
    builder: () => Scaffold(
      body: Container(
        child: Center(
          child:Image.asset(
              'assets/images/logo.png',
              width: 130.w,
              height: 130.h,),
        ),
      ),
    ));
  }
}
