import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routes.dart';
import 'model.dart';

class AuthReo{
  late UserModel userModel;

  Future createUserToFireStore(String uid,String name, String email)async{
    var setuserData= await FirebaseFirestore.instance.collection("users").doc(uid);

    Map<String, dynamic> json= {
      "uid": uid,
      "name": name,
      "email": email,

    };
    return setuserData.set(json);
  }

  Future<UserModel?> getUserFromFireStore(String uid) async {
    UserModel? getUserData;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists && value.data() != null) {
        getUserData = UserModel.fromJson(value.data()!);
      }
    });

    return getUserData;
  }


  static Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushNamed(context, Routes.homePage);
  }

}