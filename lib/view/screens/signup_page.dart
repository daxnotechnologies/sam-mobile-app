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
import 'package:sam_beckman/view/screens/login_page.dart';
import 'package:sam_beckman/view/widgets/ProgressPopUp.dart';
import 'package:sam_beckman/view/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_auth/email_auth.dart';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: () => Scaffold(
        resizeToAvoidBottomInset: true,
        body: SignupBody(),
      ),
    );
  }
}

class SignupBody extends StatefulWidget {
  SignupBody({Key? key}) : super(key: key);

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  var obscure=false;
  var obscure1=false;

  ScrollController _controller=new ScrollController();
  firebaseAuthController auth = new firebaseAuthController();
  firebaseController firestoreController = new firebaseController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController website = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();
  TextEditingController otpcontroller = new TextEditingController();
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  // EmailAuth emailAuth=new EmailAuth(
  //   sessionName: "Sample session",
  // );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Container(
          margin: EdgeInsets.only(top: 96.h, left: 24.w, right: 24.w),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 140.h,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 70.w,
                        height: 70.h,),
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
                              _text(text: 'Name'),
                              _customTextField(
                                controller: name,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please fill out this feild";
                                  }
                                  return null;
                                },
                                hintText: 'Enter your name',
                              ),
                              SizedBox(height: 16.h),
                              _text(text: 'Username'),
                              _customTextField(
                                controller: username,
                                hintText: 'Enter your username',
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please fill out this feild";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              _text(text: 'Website'),
                              _customTextField(
                                controller: website,
                                hintText: 'Enter your website',
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Please fill out this feild";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              _text(text: 'Email Address'),
                              _customTextField(
                                controller: email,
                                hintText: 'Enter your email address',
                              ),
                              SizedBox(height: 16.h),
                              _text(text: 'Password'),
                              _customPasswordField(
                                suffixicon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      obscure==true?obscure=false:obscure=true;
                                    });
                                  },
                                  icon: obscure==false?Icon(Icons.remove_red_eye_outlined,color:Colors.grey,):Icon(Icons.remove_red_eye,color:Theme.of(context).primaryColor,),
                                ),
                                isObscure: !obscure,
                                controller: password,
                                hintText: 'Enter your password',
                              ),
                              SizedBox(height: 16.h),
                              _text(text: 'Confirm Password'),
                              _customPasswordField(
                                suffixicon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      obscure1==true?obscure1=false:obscure1=true;
                                    });
                                  },
                                  icon: obscure1==false?Icon(Icons.remove_red_eye_outlined,color:Colors.grey,):Icon(Icons.remove_red_eye,color:Theme.of(context).primaryColor,),
                                ),
                                isObscure: !obscure1,
                                controller: confirmpassword,
                                hintText: 'Enter your password',
                              ),
                              SizedBox(height: 12.h),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                forgetPassword_SendCode()));
                                  },
                                  child: _text(text: 'Forgot Password?')),
                              SizedBox(height: 18.h),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                  ),
                                  onPressed: () async {
                                    var pref =
                                        await SharedPreferences.getInstance();
                                    if(password.text!=confirmpassword.text){
                                      toastempty(
                                          context,
                                          'Password doesn\'t match',
                                          Colors.red);
                                    }
                                    if (validateForm() && confirmpassword.text == password.text) {
                                      ProgressPopup(context);
                                      sendVerificationEmail(context);
                                    }
                                  },
                                  child: Text(
                                    'Signup',
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
                      SizedBox(height:300.h,)
                    ],
                  ),
                ),
              ),
              // outlined button with border color and text
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _text(text: 'Already have an account?'),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Login ()));
                        },
                        child: Text(
                          ' Login',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  sendOtp(context) {
      Navigator.pop(context);
      showModalBottomSheet(context: context, builder:(context){
        return Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Theme.of(context).primaryColor, size: 25,)),
                SizedBox(width: 10,)
              ],),
              Column(
                children: [
              SizedBox(height: 30,),
                Text('Verification Email Sent',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                
              SizedBox(height: 50,),
              Text('Please check your spam folder',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 16),),
              ],),
          ],)
        );
      });
    // if (result) {
    // }
  }

  sendVerificationEmail(context) async{
    await auth
        .signUpWithEmailAndPassword(
        email.text.trim(), password.text.trim())
        .then((value) => {
        Navigator.pop(context),
        if (value)
          {
            saveData(),
            sendMail(),
            sendOtp(context)
            
          }
        else
          {
            Navigator.pop(context),
            toastempty(
                context,
                'email already registered',
                Colors.red),
          }
      });


    }

    sendMail() async{
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }


  Image _icons({String? imagePath}) {
    return Image.asset(
      imagePath!,
      width: 24.w,
      height: 24.h,
    );
  }

  TextFormField _customTextField(
      {String? hintText,
      bool isObscure = false,
      var controller,
      var validator}) {
    return TextFormField(
      style: TextStyle(color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black),
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        isCollapsed: false,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
            Colors.white: 
            Colors.black
        ),
      ),
      validator: validator ??
          (String? value) {
            if (value!.isEmpty) {
              return "Please fill out this feild";
            } else if (!value.contains("@")) {
              return "Please enter valid email";
            }
            return null;
          },
    );
  }

  TextFormField _customPasswordField(
      {String? hintText, bool isObscure = false, var controller,var onchanged,var suffixicon}) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: TextStyle(color:  SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black),
      decoration: InputDecoration(
        suffixIcon: suffixicon??SizedBox(),
        isCollapsed: false,
        hintText: hintText ?? '',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? 
                                    Colors.white: 
                                    Colors.black
        ),
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Please fill out this feild";
        } else if (value.length <= 5) {
          return 'length must be greater than 6';
        }
        return null;
      },
      onChanged: onchanged??(value){},
      onTap: (){
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
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
    final form = formkey.currentState;
    if (form!.validate()) {
      return true;
    }
    return false;
  }

  saveData() async {
    var auth = await FirebaseAuth.instance;
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    var temp = await collectionReference.doc(auth.currentUser!.uid).set({
      'email': email.text,
      'password': password.text,
      'name': name.text,
      'username': username.text,
      'website': website.text,
      'favourites': 0,
      'imagePath': '',
      'reviews': 0,
      'followers': 0,
      'following': 0
    });
  }
}
