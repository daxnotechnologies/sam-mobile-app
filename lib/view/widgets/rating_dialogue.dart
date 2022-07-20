import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

rating_dialogue(var context,var appId,String? image){
  TextEditingController controller=new TextEditingController();
  var ratting=0.0;
  return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 400,
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height:50,),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              "Rating",
                              style: TextStyle(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  color: Colors
                                      .red.shade900),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          unratedColor: Colors.grey,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                          EdgeInsets.symmetric(
                              horizontal: 4.0),
                          itemBuilder: (context, _) =>
                              Icon(
                                Icons.star,
                                color: Colors.amber.shade300,
                              ),
                          onRatingUpdate: (rating) {
                            ratting=rating;
                            print(rating);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              "Reviews",
                              style: TextStyle(
                                  color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                  color: Colors
                                      .red.shade900),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 1,color: Colors.blue)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: TextStyle(color: Colors.black),
                                minLines: 1,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  border: InputBorder.none,
                                ),
                              ),
                              // child: RichText(
                              //   maxLines: 15,
                              //   overflow: TextOverflow.ellipsis,
                              //   text: TextSpan(
                              //     text: notes_controller.notes.value,
                              //     style: TextStyle(
                              //         color:  Colors.black,
                              //         fontSize: 12),
                              //   ),
                              // ),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          //login button
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child:  Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            addReview(appId:appId,description:controller.text,ratting:ratting,context: context);
                          },
                        ),
                      ],
                    ),
                    height: 370,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: SchedulerBinding.instance.window.platformBrightness != Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade800,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        image:image!=null?DecorationImage(image:NetworkImage(image.toString())): DecorationImage(image:AssetImage('assets/images/profile.png')),
                        shape: BoxShape.circle,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));

}
addReview({var appId, var ratting, var description,var context})async{
  if(ratting == 0.0)
    ratting = 3.0;
  var collectionReference=FirebaseFirestore.instance.collection('users');
  var currentUser= FirebaseAuth.instance.currentUser;
  var name;
  var temp = await collectionReference.doc(currentUser!.uid).get();
    name = temp['name'];
  var verified= true;
  var review=[
    {
      'commentCount': 0,
      'comments' : [],
      'description': description,
      'image': temp['imagePath'],
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'likeCount': 0,
      'likes': [],
      'time': DateTime.now(),
      'username': name,
      'verified': verified,
      'ratting': ratting,
    }
  ];

  FirebaseFirestore.instance
      .collection('apps')
      .doc(appId)
      .update({'reviews': FieldValue.arrayUnion(review)});

  FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({'reviews': FieldValue.increment(1)}).then(
          (value) => Navigator.of(context).pop());

}