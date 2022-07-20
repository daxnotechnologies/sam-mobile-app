import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../view/screens/search_page.dart';

class favouriteController extends GetxController {
  QuerySnapshot<Object?>? apps;
  List<App> Fav_appList = <App>[].obs;
  List<App> Fav_appList1 = <App>[].obs;
  List<App> reviewd_appList = <App>[].obs;
  List<App> curated_appList = <App>[].obs;

  Future<List<App>> GetRattedapps() async {
    var auth = FirebaseAuth.instance;
    var collection = await FirebaseFirestore.instance.collection('apps').get();
    print(collection.docs.elementAt(0)["reviews"]);
   reviewd_appList.isEmpty? collection.docs
    .forEach((element) {
      List? reviews=element['reviews'];
      bool add=false;
      reviews!.forEach((element) {
        print("all"+element['userId']);
        if(element["userId"]==auth.currentUser!.uid){
          print("yes"+element['userId']);
          add=true;
        }else{
          print("no"+element['userId']);
        }
      });
      if(add){
      reviewd_appList.add(App(
        applicationTitle: element['title'],
        category: element['category'],
        iconName: element['icon'],
        appId: element.id,
        description: element['description'],
        ratting: element['rating'].toString(),
        developer: element['developer'].toString(),
        link: element['playStoreLink'].toString(),
        reviewsList: element['reviews'],
        downloads: element['downloads'].toString(),
      ));
      add=false;
      print('added');
      }
    }):null;
    print("oy"+reviewd_appList.length.toString());
    return reviewd_appList;
  }
  Future<List<App>> GetCuratedapps() async {
    var auth = FirebaseAuth.instance;
    var appRequests =await FirebaseFirestore.instance.collection('app-requests').get();
    var collection = await FirebaseFirestore.instance.collection('apps').get();
    curated_appList.isEmpty?appRequests.docs.forEach((req) {
      print("there");
      if(req["userId"]==auth.currentUser!.uid){
        print(req["userId"]);
        collection.docs
            .forEach((element) {
          if(req["approved"]==true && req["appLink"]==element["playStoreLink"])
            curated_appList.add(App(
              applicationTitle: element['title'],
              category: element['category'],
              iconName: element['icon'],
              appId: element.id,
              description: element['description'],
              ratting: element['rating'].toString(),
              developer: element['developer'].toString(),
              link: element['playStoreLink'].toString(),
              reviewsList: element['reviews'],
              downloads: element['downloads'].toString(),
            ));
            print('added');
        });
      }
    }):null;
    return curated_appList;
  }
  Future<List<App>> Getapps() async {
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance.collection('favourites');
    var Mapapps = await collection.doc(auth.currentUser!.uid).get();
    List Listapps = [];
    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['appList'];
    print('hello' + Listapps.length.toString());
    Fav_appList.isEmpty?Listapps.forEach((element) {
      Fav_appList.add(App(
        applicationTitle: element['applicationTitle'],
        color: element['color'].toString(),
        category: element['category'],
        iconName: element['iconName'],
        appId: element['appId'],
        description: element['description'],
        ratting: element['ratting'].toString(),
        developer: element['developer'].toString(),
        link: element['link'].toString(),
        reviewsList: element['reviews'],
        downloads: element['downloads'].toString(),
      ));
    }):null;
    print("oy"+Fav_appList.length.toString());
    return Fav_appList;
  }
  Future<List<App>> GetUpperapps() async {
    Fav_appList1.clear();
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance.collection('favourites');
    var Mapapps = await collection.doc(auth.currentUser!.uid).get();
    List Listapps = [];
    Mapapps.data() == null ? null : Listapps = Mapapps.data()!['appList'];
    print('hello' + Listapps.length.toString());
    Fav_appList1.isEmpty? Listapps.forEach((element) {
      Fav_appList1.add(App(
        color: element['color'].toString(),
        applicationTitle: element['applicationTitle'],
        category: element['category'],
        iconName: element['iconName'],
        appId: element['appId'],
        description: element['description'],
        ratting: element['ratting'].toString(),
        developer: element['developer'].toString(),
        link: element['link'].toString(),
        reviewsList: element['reviews'],
        downloads: element['downloads'].toString(),
      ));
    }):null;
    print("oy"+Fav_appList1.length.toString());
    return Fav_appList1;
  }
  addFav(var currentApp,BuildContext context) async {
    // Fluttertoast.showToast(msg:'❤',backgroundColor: Colors.transparent,textColor: Colors.red,fontSize: 50,timeInSecForIosWeb:1,gravity: ToastGravity.CENTER);
    var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance.collection('favourites');
    var Mapapps = await collection.doc(auth.currentUser!.uid).get();
    List Listapps = [];
    Mapapps.data()!=null? Listapps = Mapapps.data()!['appList'] : null;
    print('hello' + Listapps.length.toString());
    var add = true;
    Listapps.forEach((element) {
      if (element['appId'] == currentApp['appId']) {
        add = false;  
        print(element);
      }
    });
    if (!add) {
      collection
          .doc(auth.currentUser!.uid)
          .update(// <-- Doc ID where data should be updated.
          {
            'appList': FieldValue.arrayRemove([currentApp]),
          });
      add = true;
    } else {
      Listapps.add(currentApp);

      Mapapps.data()!=null?collection
          .doc(auth.currentUser!.uid)
          .update(// <-- Doc ID where data should be updated.
          {
            'appList': FieldValue.arrayUnion(Listapps),
          }):collection
          .doc(auth.currentUser!.uid)
          .set(// <-- Doc ID where data should be updated.
          {
            'appList': FieldValue.arrayUnion(Listapps),
          });

    }
  }
}
