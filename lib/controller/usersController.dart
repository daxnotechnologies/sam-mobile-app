import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../model/video_models.dart';
import '../view/screens/search_page.dart';

class usersController extends GetxController {
  List usersList = [].obs;
  List curatedList = [].obs;
  List curatedListIcon = [].obs;
  Future<List<Video>>? videos;


  Future<List> GetFollowings(userId) async{
    var auth = FirebaseAuth.instance;
    var collection = await FirebaseFirestore.instance.collection('following').doc(userId).get();
    usersList=collection['userId'];
    return usersList;
  }
  Future<List> GetFollowers(userId) async{
    usersList.clear();
    var auth = FirebaseAuth.instance;
    var collection = await FirebaseFirestore.instance.collection('following').get();
    collection.docs.forEach((element) {
      List users=element['userId'];
      users.forEach((element2) {
        if(element2.toString() == userId.toString()){
          usersList.add(element2);
        }
      });
    });
    return usersList;
  }
}
