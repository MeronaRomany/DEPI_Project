import 'package:depi_project/core/constant/app_image.dart';
import 'package:depi_project/features/Auth/data/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_color.dart';
import '../../../../../../core/constant/app_string.dart';
import '../../../../../../core/routing/routes.dart';
// import '../../services/firestore_service.dart';

class SignUpMobileLayout extends StatefulWidget {
  const SignUpMobileLayout({super.key});

  @override
  State<SignUpMobileLayout> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpMobileLayout> {
  final formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  bool isNotVisible = true;
  late AuthReo usersFireStore = AuthReo();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Appcolor.kWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0,right: 20.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Image.asset(AppImage.logoMap,height: 60,width: 60,),
                Text(
                  AppString.kSignUP,
                  style: TextStyle(fontSize: width * 0.06, fontWeight: FontWeight.bold,color: Appcolor.kblack),
                ),

                Text(
                  AppString.klet_us_Know,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.kgrey,
                  ),
                ),
                SizedBox(height: height * 0.02),

                TextFormField(
                  controller: username,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please, Enter your Full name";
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 18,color: Appcolor.kgrey),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    labelText: AppString.kFullName,
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Appcolor.kgrey,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

                TextFormField(
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please, enter your email";
                    }

                    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    RegExp regex = RegExp(pattern);

                    if (!regex.hasMatch(value)) {
                      return "Please, enter a valid email";
                    }

                    return null;
                  },
                  style: TextStyle(fontSize: 18,color: Appcolor.kgrey),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    labelText: AppString.kEmail,

                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Appcolor.kgrey,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:  Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

                TextFormField(
                  controller: password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please, Enter your password";
                    }
                    if (value.length < 6) {
                      return "please, should be at least 6 char";
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 20,color: Appcolor.kgrey),
                  textInputAction: TextInputAction.search,
                  obscureText: isNotVisible,

                  decoration: InputDecoration(
                    labelText: AppString.kPassword,
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Appcolor.kgrey,
                      fontWeight: FontWeight.bold,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        changePasswordVisible(!isNotVisible);
                        setState(() {});
                      },
                      icon: Icon(
                        isNotVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Appcolor.kgrey,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: height * 0.02),

                GestureDetector(
                  onTap: ()  {
                    signUp(context);
                  },
                  child: Container(
                    height:height * 0.07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor.kblack,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Center(
                      child: Text(
                        AppString.kSignUP,
                        style: TextStyle(
                          fontSize: width*0.06,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: height * 0.015),

                Text(
                  AppString.kOrSignUPWith,
                  style: TextStyle(fontSize:width * 0.035, fontWeight: FontWeight.bold,color: Appcolor.kgrey),
                ),
                 // SizedBox(height: height * 0.015),

                GestureDetector(

                  onTap: ()async{
                    await AuthReo.signInWithGoogle(context);

                  },
                  child: Container(
                    height: height * 0.07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor.kred,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Center(
                      child: Text(
                        AppString.kGmail,
                        style: TextStyle(
                          fontSize:width*0.06,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: height * 0.015),

                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        AppString.kAlready_have_an_account,
                        style: TextStyle(fontSize: width*0.04, color: Appcolor.kgrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.signIn);
                        },
                        child: Text(
                          AppString.kSignINNow,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize:width*0.03,
                            color: Appcolor.kgrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changePasswordVisible(bool visible) {
    if (isNotVisible == visible) {
      return;
    } else {
      isNotVisible = visible;
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (!formkey.currentState!.validate()) return;

    try {
      final data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = data.user!.uid;
      await usersFireStore.createUserToFireStore(
        uid,
        username.text.trim(),
        email.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        print("✅ Verification Email Sent");
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Sign Up Successful"),
          content: const Text(
            "Please check your email to verify your account before logging in.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context,"verfiy email");
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Sign Up Failed"),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

}
