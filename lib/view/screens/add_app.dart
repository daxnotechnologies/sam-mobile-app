import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class addApp extends StatefulWidget {
  const addApp({Key? key}) : super(key: key);

  @override
  State<addApp> createState() => _addAppState();
}

class _addAppState extends State<addApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: () =>  Scaffold(
        body: addAppBody(),
      ),
    );
  }
}

class addAppBody extends StatelessWidget {
  addAppBody({Key? key}) : super(key: key);
  TextEditingController email=new TextEditingController();
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formkey,
        child: Container(
          margin: EdgeInsets.only(top: 96.h, left: 24.w, right: 24.w),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 174.h,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Image.asset(
                    'assets/images/logo.png',
                    width: 70.w,
                    height: 70.h,),
                    SizedBox(height: 24.h),
                    Card(
                      elevation: 3,
                      color: Colors.white,
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
                            _text(text: 'App Url'),
                            _customTextField(
                              controller: email,
                              hintText: 'Enter app Url',
                            ),
                            SizedBox(height: 24.h),
                            SizedBox(
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
                                  ProgressPopup(context);
                                  if(validateForm()){
                                        FirebaseFirestore.instance
                                            .collection('app-requests')
                                            .add({
                                          'appLink': email.text,
                                          'approved': false,
                                          'userId': FirebaseAuth
                                              .instance.currentUser!.uid,
                                        }).then((value) => {
                                          Navigator.pop(context),
                                          Navigator.pop(context),
                                          Fluttertoast.showToast(msg: 'Your request submitted successfully')});
                                      }
                                    },
                                child: Text(
                                  'Submit',
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
              ])
      )
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
}
