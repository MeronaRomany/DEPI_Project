import 'package:depi_project/core/constant/app_color.dart';
import 'package:depi_project/core/constant/app_string.dart';
import 'package:depi_project/features/Auth/data/repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_image.dart';
import '../../../../../../core/routing/routes.dart';

class SignInMobileLayout extends StatefulWidget {
  const SignInMobileLayout({super.key});

  @override
  State<SignInMobileLayout> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInMobileLayout> {
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isNotVisible = true;
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
              spacing: 10,
              children: [
                Image.asset(AppImage.logoMap, height: 60, width: 60),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppString.kWelcome,
                    style: TextStyle(
                      fontSize: width*0.06,
                      fontWeight: FontWeight.bold,
                      color: Appcolor.kblack,
                    ),
                  ),
                ),
                Text(
                  AppString.kSignin_to_continue,
                  style: TextStyle(
                    fontSize: width*0.06,
                    fontWeight: FontWeight.bold,
                    color: Appcolor.kgrey,
                  ),
                ),
                SizedBox(height: height * 0.02),

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
                  style: TextStyle(fontSize: 18, color: Appcolor.kgrey),
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
                      borderSide: BorderSide(color: Appcolor.kgrey, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Appcolor.kgrey, width: 2.0),
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
                  style: TextStyle(fontSize: 18, color: Appcolor.kgrey),
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
                      borderSide: BorderSide(color: Appcolor.kgrey, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Appcolor.kgrey, width: 2.0),
                    ),
                  ),
                ),
               // SizedBox(height: height * 0.015),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.forgetPass);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppString.kForgetPassword,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.kgrey,
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          )
                          .then((data) async {
                            if (!data.user!.emailVerified) {
                              await FirebaseAuth.instance.signOut();

                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text("Email not verified"),
                                  content: Text(
                                    "يرجى تأكيد البريد الإلكتروني أولاً",
                                  ),
                                ),
                              );

                              return;
                            }

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Login successful"),
                                content: Text("Welcome ${data.user!.email}"),
                              ),
                            );

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.homePage,
                                  (route) => false,
                            );
                      })
                          .catchError((error) {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                title: Text("Login unsuccessful"),
                                content: Text(
                                  "Please check your email or password.",
                                ),
                              ),
                            );
                          });
                    }
                  },
                  child: Container(
                    height: height*0.07,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor.kblack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Center(
                      child: Text(
                        AppString.kSignIN,
                        style: TextStyle(
                          fontSize: width*0.06,
                          fontWeight: FontWeight.bold,
                          color:Appcolor.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: height * 0.015),

                //Spacer(),
                Text(
                  AppString.kOrSignInWith,
                  style: TextStyle(color: Appcolor.kgrey, fontSize:width * 0.035),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await AuthReo.signInWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appcolor.kred,
                    ),
                    label: Text(
                      AppString.kSignInGoogle,
                      style: TextStyle(color: Appcolor.kWhite, fontSize: 18),
                    ),
                    icon: SizedBox(width:60,child: Image.asset(AppImage.logoGoogle,width: 20,height: 20,)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        AppString.kDon_tHaveAnAccount,
                        style: TextStyle(fontSize: width*0.05, color:Appcolor.kgrey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.signUp);
                        },
                        child: Text(
                          AppString.kSign_up_now,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: width*0.04,
                              color:Appcolor.kgrey,
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
}
