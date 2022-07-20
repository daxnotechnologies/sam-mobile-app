import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class firebaseController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Future<void> addUser({var name, var email, var password}) {

    // Call the user's CollectionReference to add a new user
    return users
        .add({'name': name, 'email': email, 'password': password,'favourite':['','']})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

}
