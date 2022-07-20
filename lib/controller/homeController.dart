import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

import '../view/screens/search_page.dart';
import 'package:http/http.dart' as http;

class homeController extends GetxController{
  QuerySnapshot<Object?>? apps;
  var category=''.obs;
  var add=true;
  List<App> catagoryList=<App>[].obs;
  List<App> appList=<App>[].obs;
  List<App> catagoryAppList=<App>[].obs;
  List<App> favouritesList=<App>[].obs;
  Future ft = Future((){});

  Future<QuerySnapshot<Object?>?> GetCatagories() async {
    apps = await FirebaseFirestore.instance.collection('apps').get();
    apps!.docs.forEach((element) {
      print(element.toString());
      catagoryList.forEach((element1) {
        if(element1.category == element['category'])
          add=false;  
      });
      if(add){
        catagoryList.add(App(
          applicationTitle:element['title'],
          category :element['category'],
        ));
        add=true;
      }});

    print(catagoryList.length);
    print(apps);
    return apps;
  } 
  Future<QuerySnapshot<Object?>?> Getapps() async {
    int i = 0;
    apps = await FirebaseFirestore.instance.collection('apps').get();
    apps!.docs.forEach((element) {
      ft = ft.then((value) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          print(element.id); 
            appList.add(App(
            applicationTitle:element['title'],
            category :element['category'],
            iconName : element['icon'],
            appId : element.id,
            description :element['description'],
            ratting : element['rating'].toString(),
            developer : element['developer'].toString(),
            link : element['playStoreLink'].toString(),
            publish: element['uploadedAt'].toString(),
            color: element['color'].toString(),
            downloads: element['downloads'].toString(),
            reviewsList: element['reviews'],
          ));
          i = i + 1;
        });
        });
    });
    print("App List" + appList.length.toString());
    return apps;
  }

  Future<QuerySnapshot<Object?>?> GetappsOfCatagory() async {
    catagoryAppList.clear();
    apps = await FirebaseFirestore.instance.collection('apps').get();
    if(apps != null) {
      int i = 0;
      apps!.docs.forEach((element) {
      ft = ft.then((value) {
        return Future.delayed(const Duration(milliseconds: 100), () {
          if(category.value == element['category'].toString().toLowerCase()){
              catagoryAppList.add(App(
              color:element['color'].toString() ,
              applicationTitle:element['title'],
              category :element['category'],
              iconName : element['icon'],
              appId : element.id,
              description :element['description'],
              ratting : element['rating'].toString(),
              developer : element['developer'].toString(),
              link : element['playStoreLink'].toString(),
              publish: element['uploadedAt'].toString(),
              downloads: element['downloads'].toString(),
              reviewsList: element['reviews'].toString(),
            ));
            i = i + 1;
          }
        });
        });        
        });
    } 
    print(catagoryAppList.length);
    return apps;
  }

}