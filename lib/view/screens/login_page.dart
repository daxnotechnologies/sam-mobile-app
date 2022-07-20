import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sam_beckman/controller/firebaseAuthController.dart';
import 'package:sam_beckman/controller/firebaseController.dart';
import 'package:sam_beckman/view/screens/changepass_page.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/signup_page.dart';
import 'package:sam_beckman/view/widgets/ProgressPopUp.dart';
import 'package:sam_beckman/view/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {



  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: () =>  Scaffold(
        body: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  firebaseAuthController auth=new firebaseAuthController();

  firebaseController firestoreController=new firebaseController();

  TextEditingController email=new TextEditingController();

  TextEditingController password=new TextEditingController();

  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Container(
          margin: EdgeInsets.only(top: 80.h, left: 24.w, right: 24.w),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 174.h,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 65.w,
                      height: 65.h,
                    ),
                    SizedBox(height: 24.h),
                    Card(
                      elevation: 3,
                      color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                      Color(0xff46454D) :
                      Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 28.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _text(text: 'Email Address'),
                            TextFormField(
                              style: TextStyle(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black
                              ),
                              controller: email,
                              obscureText: false,
                              decoration: InputDecoration(
                                isCollapsed: false,
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black
                                ),
                              ),
                              validator:  (String? value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this feild";
                                }else if (!value.contains("@")) {
                                  return "Please enter valid email";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            _text(text: 'Password'),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              style: TextStyle(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black
                              ),
                              decoration: InputDecoration(
                                
                                isCollapsed: false,
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                  Colors.white :
                                  Colors.black
                                ),
                              ),
                              validator:  (String? value) {
                                if (value!.isEmpty) {
                                  return "Please fill out this feild";
                                }else
                                if(value.length<=5){
                                  return 'length must be greater than 6';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 12.h),
                            InkWell( onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>forgetPassword_SendCode()));
                            },child: _text(text: 'Forgot Password?')),
                            SizedBox(height: 18.h),
                            Container(
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
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  elevation: 4,
                                  shadowColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                ),
                                onPressed: ()async{
                                  var pref=await SharedPreferences.getInstance();
                                  if(validateForm()){
                                    ProgressPopup(context);
                                    auth.signInWithEmailAndPassword(email.text, password.text).then((value) => {
                                      FocusManager.instance.primaryFocus?.unfocus(),
                                      Navigator.pop(context),
                                      if(FirebaseAuth.instance.currentUser != null){
                                         if(FirebaseAuth.instance.currentUser!.emailVerified == true){
                                          if(value == "true"){
                                            pref.setBool('logined',true),
                                            setState(() {
                                              
                                            }),
                                            print("zzzzzzzzzzzzzzzz" + pref.get('logined').toString()),

                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => Home())),
                                                    
                                              print("logedInnnnn"),
                                          }
                                        } else {
                                          toastempty(
                                            context,
                                            'Email Not Verified',
                                            Colors.red),

                                            FirebaseAuth.instance.signOut(),
                                        },
                                      } else {
                                        if(value == "email"){
                                          toastempty(
                                            context,
                                            'Incorrect Email',
                                            Colors.red),
                                        }
                                        else if(value == "password"){
                                          toastempty(
                                              context,
                                              'Incorrect Password',
                                              Colors.red),
                                        }
                                      }
                                      
                                    });
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    _text(text: 'Or sign in with'),
                    SizedBox(height: 26.25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Ink(
                          decoration: BoxDecoration(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child:Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 25.w,
                              height: 25.h,
                             decoration: BoxDecoration(
                               image: DecorationImage(
                                 image: AssetImage(
                                     'assets/icons/facebook.png'
                                 ),
                                 fit: BoxFit.fill
                               )
                             ),
                            ),
                          ),
                        ),
                        // Container(
                        //   decoration: BoxDecoration(

                        //   ),
                        //   child: _icons(imagePath: 'assets/icons/facebook.png')),
                        SizedBox(width: 20.w),
                         Ink(
                          decoration: BoxDecoration(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/icons/twitter.png'
                                      ),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 20.w),

                        GestureDetector(
                          onTap: () async{
                            var pref=await SharedPreferences.getInstance();
                            auth.GoogleSignOpt().then((value) => {
                              print('yaha'),
                              if(value){
                                saveData(),
                              }else{
                                
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Ink(
                                width: 43.w,
                                height: 43.h,
                                  decoration: BoxDecoration(
                                      color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child:Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: 35.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/google.png'
                                          ),
                                          fit: BoxFit.fill
                                      )
                                  ),
                                ),
                              ),),
                          ),
                        ),
                        SizedBox(width:20.w),
                          Ink(
                            height: 43,
                            width: 43,
                          decoration: BoxDecoration(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          
                          child:Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/icons/microsoft.png'
                                      ),
                                      fit: BoxFit.fill
                                  )
                              ),
                            ),
                          ),
                        ),
                    

                      ],
                    ),

                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Signup()));
                            },
                            child: Text('Sign up with email',style: TextStyle(color: Theme.of(context).primaryColor),)),
                      ],
                    ),
                    SizedBox(height: 26.25.h),
                  ],
                ),
              ),
              // outlined button with border color and text
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    backgroundColor: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                    Color(0xff46454D) :
                    Colors.white,
                    elevation: 0,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      side: BorderSide(
                        color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                          Colors.transparent :
                        Theme.of(context).primaryColor,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                  onPressed: () async{
                    SharedPreferences pref=await SharedPreferences.getInstance();
                    ProgressPopup(context);
                    if(FirebaseAuth.instance.currentUser != null)
                      FirebaseAuth.instance.signOut();
                    FirebaseAuth.instance.signInWithEmailAndPassword(email: "guest@gmail.com", password: "123456").then((value)=>{
                      Navigator.pop(context),
                                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Home())),

                    });
                  },
                  child: Text(
                    'View as a guest',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ?
                          Colors.white :
                          Theme.of(context).primaryColor
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image _icons({String? imagePath}) {
    return Image.asset(
      imagePath!,
      width: 24.w,
      height: 24.h,
    );
  }

  TextFormField _customTextField({String? hintText, bool isObscure = false,var controller}) {
    return TextFormField(
      style: TextStyle(
          color: Colors.black
      ),
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        isCollapsed: false,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
      validator:  (String? value) {
        if (value!.isEmpty) {
          return "Please fill out this feild";
        }else if (!value.contains("@")) {
          return "Please enter valid email";
        }
        return null;
      },
    );
  }

  TextFormField _customPasswordField({String? hintText, bool isObscure = false,var controller,var suffixicon}) {
    var obscure=false;
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(
          color: Colors.black
      ),
      decoration: InputDecoration(
        suffixIcon: suffixicon??SizedBox(),
        isCollapsed: false,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
      validator:  (String? value) {
        if (value!.isEmpty) {
          return "Please fill out this feild";
        }else
        if(value.length<=5){
          return 'length must be greater than 6';
        }
        return null;
      },
    );
  }

  Text _text({String? text}) {
    return Text(
      text ?? '',
      style: TextStyle(
        fontSize: 12.sp,
        color: const Color.fromARGB(255, 172, 172, 172),
      ),
    );
  }

  bool validateForm() {
    final form =formkey.currentState;
    if (form!.validate()) {
      return true;
    }
    return false;
  }

  saveData() async {
    
    var pref=await SharedPreferences.getInstance();

    var auth=await FirebaseAuth.instance;
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection('users');
    var follower=0;
    var following=0;
    var password='';
    var reviews=0;
    try {
     var userdata= await FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).get();
     following=userdata['following'];
     follower=userdata['followers'];
     password=userdata['password'].toString();
     reviews=userdata['reviews'];
    }catch(ex){

    }
    var temp = await collectionReference.doc(auth.currentUser!.uid).set({
      'email': auth.currentUser!.email,
      'password': password,
      'name': auth.currentUser!.displayName,
      'username': auth.currentUser!.displayName,
      'website': 'No website added',
      'favourites': 0,
      'imagePath': auth.currentUser!.photoURL,
      'reviews': reviews,
      'followers':follower,
      'following': following
    }).then((value) => {  
      pref.setBool('logined',true),
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => Home())),
    });

  }
}
