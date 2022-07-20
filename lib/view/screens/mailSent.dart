import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sam_beckman/view/screens/login_page.dart';

import '../widgets/textfield.dart';
import 'changepass_page.dart';

class emailSent extends StatefulWidget {
  const emailSent({Key,key}) : super(key: key);

  @override
  _emailSentState createState() => _emailSentState();
}

class _emailSentState extends State<emailSent> {
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
              Text(
                'Email has been sent!',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height:10),
              Flexible(child: const Text("Please check your inbox and click")),
              Flexible(child: const Text("the recieved link to reset password")),
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
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: const Text("Email not recieved? ")),
                  InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>forgetPassword_SendCode(
                        )));
                      },
                      child: Text("Resend",style: TextStyle(color: Theme.of(context).primaryColor),)),

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
                  "Login",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login(
    )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}