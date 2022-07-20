import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sam_beckman/controller/firebaseController.dart';

class firebaseAuthController {
  fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  firebaseController controller=new firebaseController();
  Future GoogleSignOpt() async {
    print("a gya");
    GoogleSignInAccount _user;
    var googlesignIn = GoogleSignIn();
    var googleUsers = await googlesignIn.signIn();
    print(googleUsers?.email);
    if (googleUsers == null) return;
    _user = googleUsers;
    final googleAuth = await googleUsers.authentication;
    print(googleAuth.idToken);
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    //1
    var data = await signInWithGoogle(credential);
    print("hello" + data.toString());
    return data;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      fba.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        return "true";
      } else {
        return "false";
      }
    } catch (e) {   
      log(e.toString());
      if(e.toString().contains("password"))
        return "password";
      else if (e.toString().contains("email"))
        return "email";
      return "other";

    }
  }
  Future<bool> signInWithGoogle(var credentials) async {
    try {
      fba.UserCredential result = await _auth.signInWithCredential(credentials);
      if (result.user != null) {
       // controller.addUser(name:result.user!.displayName ,email:result.user!.email ,password: result.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
        print("SignUp Before");

    fba.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

        print("SignUp After");
    if (result.user != null) {
    //  controller.addUser(name:result.user!.displayName ,email:result.user!.email ,password: result.user!.uid);
      return true;
    } else {
      return false;
    }
  }
  Future signOut() async {
    var googlesignIn = GoogleSignIn();
    if(googlesignIn.currentUser != null)
      return await googlesignIn.signOut();
    else 
      return await _auth.signOut();
    // googlesignIn.signOut();
    // return await _auth.signOut();
  }
}
