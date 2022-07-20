import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sam_beckman/view/screens/login_page.dart';
import 'package:sam_beckman/view/screens/mailSent.dart';

import '../widgets/textfield.dart';

class forgetPassword_SendCode extends StatefulWidget {
  const forgetPassword_SendCode({Key,key}) : super(key: key);

  @override
  _forgetPassword_SendCodeState createState() => _forgetPassword_SendCodeState();
}

class _forgetPassword_SendCodeState extends State<forgetPassword_SendCode> {
  double gapHeight = 15;
  bool isRemember = false;

  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

  TextEditingController emailController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text(
                  'Forgot your Password?',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height:10),
              Flexible(child: const Text("Welcome! Please enter Your registered")),
              Flexible(child: const Text(" email to reset password.")),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Image.asset(
                      "assets/images/images.png",
                      // width: 600.0,
                      // height: 240.0,
                      // color:  MediaQuery.of(context).platformBrightness ==
                      //     Brightness.dark
                      //     ? Colors.white
                      //     : Colors.black,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Form(
                  key: globalFormKey,
                  child: CustomTextFormFieldWithPrefix(
                    prefixIcon: Icon(Icons.email),
                    controller: emailController,
                    hintText: "Enter your email",
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: const Text("Remember password?  ")),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login(
                        )));
                      },
                      child: Text("Login",style: TextStyle(color: Theme.of(context).primaryColor),)),

                ],
              ),
              SizedBox(height: 10,),
              ElevatedButton(
                //login button
                style: ElevatedButton.styleFrom(
                  // backgroundColor: darkBlueColor,
                  primary:  Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if(validateForm()){
                    try{
                      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>emailSent(
                        )));

                    //await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                  }catch(ex){
                      throw Exception(ex);
                    }

                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool validateForm() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      return true;
    }
    return false;
  }
}