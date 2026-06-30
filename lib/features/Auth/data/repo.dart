import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/routing/routes.dart';
import 'model.dart';

class AuthReo{
  late UserModel userModel;

  Future createUserToFireStore(String uid,String name, String email)async{
    var setuserData= FirebaseFirestore.instance.collection("users").doc(uid);

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
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("User canceled");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homePage,
            (route) => false,
      );
    } catch (e) {
      print("GOOGLE ERROR = $e");
    }
  }

  }