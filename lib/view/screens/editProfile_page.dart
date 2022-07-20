import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sam_beckman/model/profile.dart';
import 'package:sam_beckman/view/screens/user_profile_page.dart';
import 'package:sam_beckman/view/widgets/ProgressPopUp.dart';
import 'package:sam_beckman/view/widgets/toast.dart';

class editProfile_page extends StatefulWidget {
  editProfile_page({Key, key,this.profile}) : super(key: key);
  Profile? profile;
  @override
  _editProfile_pageState createState() => _editProfile_pageState();
}

class _editProfile_pageState extends State<editProfile_page> {
  TextEditingController emails=new TextEditingController();
  TextEditingController name=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController confirmpassword=new TextEditingController();
  TextEditingController username=new TextEditingController();
  TextEditingController website=new TextEditingController();
  TextEditingController oldpassword=new TextEditingController();

  String ?imageUrl;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height:250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:  MediaQuery.of(context).platformBrightness !=
                          Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text('Edit Profile',style:TextStyle(
                            fontSize: 18,fontWeight: FontWeight.bold,color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        )),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(type : FileType.image);
                            if(result != null) {
                              final croppedFile = await ImageCropper().cropImage(
                                aspectRatioPresets: [CropAspectRatioPreset.square],
                                sourcePath: result.files.elementAt(0).path!,
                                compressFormat: ImageCompressFormat.jpg,
                                compressQuality: 100,
                              );
                              var file;
                              if (croppedFile != null) {
                                setState(() {
                                 file = croppedFile.path;
                                });
                              }else{
                                var file = result.files.single.path;
                              }
                              var name= result.files.single.name;
                              FirebaseStorage storage = FirebaseStorage.instance;
                              Reference ref = storage.ref().child('profile_images').child(name);
                              await ref.putFile(File(file!));
                              imageUrl = await ref.getDownloadURL();
                              widget.profile!.imagePath = imageUrl!;
                              setState(() {
                                
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2,color: Colors.grey),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(widget.profile!.imagePath),
                                          fit: BoxFit.scaleDown
                                      ),
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow),
                                  child: Icon(Icons.edit,color: Colors.white,size: 10,),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Text('${widget.profile!.name.toString()}',style:TextStyle(
                            fontSize: 20,fontWeight: FontWeight.bold,color:SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        )),
                        SizedBox(height: 10,),
                        Text('${widget.profile!.username.toString()}',style:TextStyle(
                            fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text('Email Address',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: emails,
                    decoration: InputDecoration(
                        hintText: '${widget.profile!.email.toString()}'
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Name',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller:name,
                    decoration: InputDecoration(
                        hintText: '${widget.profile!.name.toString()}'
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Username',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check_circle_outline,color: Colors.green.shade300,),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green.shade300)),
                        hintText: '${widget.profile!.username.toString()}'
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Enter Old Password',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: oldpassword,
                    decoration: InputDecoration(
                        hintText: ''
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Change Password',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter New Password'
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Confirm Password',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: confirmpassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Website',style:TextStyle(
                      fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                  )),
                  TextFormField(
                    controller: website,
                    decoration: InputDecoration(
                        hintText: '${widget.profile!.web.toString()}'
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        //login button
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: darkBlueColor,
                          primary: Theme.of(context)
                              .primaryColor,
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal: 30),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor,
                                width: 0.5),
                            borderRadius:
                            BorderRadius.circular(
                                10),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                        onPressed: () async {
                          if(widget.profile!.password.toString() == oldpassword.text){
                            if(password.text!=confirmpassword.text){
                              Fluttertoast.showToast(msg: 'New Password doent\'t match');
                            }
                            if(password.text.characters.length>6 && password.text==confirmpassword.text){
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Material(
                                    child: Container(
                                        height: 100,
                                        width: 100,
                                        child:
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text('Are you sure you want to save changes!',style:TextStyle(
                                                fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                                            )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  //login button
                                                  style: ElevatedButton.styleFrom(
                                                    // backgroundColor: darkBlueColor,
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 30),
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                  //login button
                                                  style: ElevatedButton.styleFrom(
                                                    // backgroundColor: darkBlueColor,
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 30),
                                                    shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Theme.of(context)
                                                              .primaryColor,
                                                          width: 0.5),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    var auth = FirebaseAuth.instance;
                                                    var users=auth.currentUser;
                                                    try {
                                                      password.text.isNotEmpty
                                                          ? FirebaseAuth.instance
                                                          .currentUser
                                                          ?.updatePassword(
                                                          password.text)
                                                          : null;
                                                      emails.text.isNotEmpty
                                                          ? FirebaseAuth.instance
                                                          .currentUser
                                                          ?.updatePassword(
                                                          emails.text)
                                                          : null;
                                                    }catch(ex){
                                                      Fluttertoast.showToast(msg: 'Please Login again to edit profile');
                                                      return null;
                                                    }
                                                    var Reference = FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(auth.currentUser!.uid);
                                                    var user = await Reference.get();
                                                    ProgressPopup(context);
                                                    Reference.update({
                                                      'email': emails.text.isNotEmpty?emails.text:widget.profile?.email,
                                                      'favourites': widget.profile?.favourites,
                                                      'followers': widget.profile?.followers,
                                                      'following': widget.profile?.following,
                                                      'imagePath': imageUrl==null?widget.profile?.imagePath:imageUrl,
                                                      'name': name.text.isEmpty?widget.profile?.name:name.text,
                                                      'password': password.text.isEmpty?widget.profile?.password:password.text,
                                                      'reviews': widget.profile?.reviews,
                                                      'username': username.text.isEmpty?widget.profile?.username:username.text,
                                                      'website': website.text.isEmpty?widget.profile?.web:website.text
                                                    }).then((value) => {
                                                      emails.clear(),
                                                      password.clear(),
                                                      username.clear(),
                                                      website.clear(),
                                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserProfilePage()))
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),

                                          ],
                                        )

                                    ),
                                  );

                                },
                              );
                            }else{
                              if(password.text.isNotEmpty)
                              Fluttertoast.showToast(msg: 'Password Must contain atleast 6 characters',);
                              else
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Material(
                                      child: Container(
                                          height: 100,
                                          width: 100,
                                          child:
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text('Are you sure you want to save changes!',style:TextStyle(
                                                  fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey
                                              )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    //login button
                                                    style: ElevatedButton.styleFrom(
                                                      // backgroundColor: darkBlueColor,
                                                      primary: Theme.of(context)
                                                          .primaryColor,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 30),
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            width: 0.5),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  ElevatedButton(
                                                    //login button
                                                    style: ElevatedButton.styleFrom(
                                                      // backgroundColor: darkBlueColor,
                                                      primary: Theme.of(context)
                                                          .primaryColor,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 30),
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                            color: Theme.of(context)
                                                                .primaryColor,
                                                            width: 0.5),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      var auth = FirebaseAuth.instance;
                                                      var users=auth.currentUser;
                                                      // FirebaseAuth.instance.signInWithEmailAndPassword(email:widget.profile!.email!, password:widget.profile!.password!);
                                                      password.text.isNotEmpty? FirebaseAuth.instance.currentUser?.updateEmail(widget.profile!.email!):null;
                                                      var Reference = FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(auth.currentUser!.uid);
                                                      var user = await Reference.get();
                                                      ProgressPopup(context);
                                                      Reference.update({
                                                        'email': widget.profile?.email,
                                                        'favourites': widget.profile?.favourites,
                                                        'followers': widget.profile?.followers,
                                                        'following': widget.profile?.following,
                                                        'imagePath': imageUrl==null?widget.profile?.imagePath:imageUrl,
                                                        'name': name.text.isEmpty?widget.profile?.name:name.text,
                                                        'password': password.text.isEmpty?widget.profile?.password:password.text,
                                                        'reviews': widget.profile?.reviews,
                                                        'username': username.text.isEmpty?widget.profile?.username:username.text,
                                                        'website': website.text.isEmpty?widget.profile?.web:website.text
                                                      }).then((value) => {
                                                        emails.clear(),
                                                        password.clear(),
                                                        username.clear(),
                                                        website.clear(),
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>UserProfilePage()))
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),

                                            ],
                                          )

                                      ),
                                    );

                                  },
                                );
                            }
                          } else {
                              Fluttertoast.showToast(msg: 'Incorrect Old Password');
                          }

                        },
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
