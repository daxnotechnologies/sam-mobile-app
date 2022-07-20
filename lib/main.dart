import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sam_beckman/view/screens/home_page.dart';
import 'package:sam_beckman/view/screens/obBoardingScreen.dart';
import 'package:sam_beckman/view/screens/onboarding_page.dart';
import 'package:sam_beckman/view/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/mybehaviour.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shelf', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 254 , 192, 1),
        fontFamily: 'Satoshi',
      ),
      darkTheme: ThemeData( 
        brightness: Brightness.dark,  
        primaryColor: const Color.fromARGB(255, 254, 192, 1),
        fontFamily: 'Satoshi',
      ),
      home:splashScreen(),
    );
  }
}
