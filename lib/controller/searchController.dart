import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../view/screens/search_page.dart';

class searchController extends GetxController{
  QuerySnapshot<Object?>? apps;
  var category=''.obs;
  var add=true;
  var searchitem = true.obs;
  List<App> appList=<App>[].obs;
  List<App> searchList=<App>[].obs;
  var latest=false.obs;
  var older=false.obs;
  var popular=false.obs;

  Future<List<App>> GetPopular() async {
    apps = await FirebaseFirestore.instance.collection('apps').orderBy('rating', descending: true).get();
    apps!.docs.forEach((element) {
          appList.add(App(
          color: element['color'],
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
        
      });

    print(appList.length);
    return appList;
  }
  Future<List<App>> GetLatest() async {
    apps = await FirebaseFirestore.instance.collection('apps').orderBy('uploadedAt', descending: true).get();
    apps!.docs.forEach((element) {
          appList.add(App(
            color: element['color'],
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
      });

    print(appList.length);
    return appList;
  }
  Future<List<App>> GetOlder() async {
    apps = await FirebaseFirestore.instance.collection('apps').orderBy('uploadedAt').get();
    apps!.docs.forEach((element) {
          appList.add(App(
            color: element['color'],
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
        add=true;
      });

    print(appList.length);
    return appList;
  }
  Future<List<App>> Getapps() async {
    apps = await FirebaseFirestore.instance.collection('apps').get();
    apps!.docs.forEach((element) {
      appList.add(App(
      color: element['color'],
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
    ));});
    print(appList.length);
    return appList;
  }
  Future<List<App>> GetappsOfCatagory() async {
    appList.clear();
    apps = await FirebaseFirestore.instance.collection('apps').get();
    apps!.docs.forEach((element) {
      if(category.value==element['category'].toString().toLowerCase()) {
        appList.add(App(
          color: element['color'],
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
      }
        
        });
    print(appList.length);
    return appList;
  }

}