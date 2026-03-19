
import 'package:depi_project/core/constant/app_color.dart';
import 'package:depi_project/core/constant/app_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordMobileLayout extends StatelessWidget {
  const ForgetPasswordMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    TextEditingController email = TextEditingController();
    return Scaffold(
      backgroundColor: Appcolor.kWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              spacing: 20,
              children: [
                Text(
                  AppString.kForgetPassword,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Appcolor.kblack),
                ),
                SizedBox(height: 10),
                Text(
                  AppString.kEmailVerifiy,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color:Appcolor.kgrey ),
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


                SizedBox(height: 10),

                GestureDetector(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {

                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text.trim())
                          .then((_) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text("Reset password email sent"),
                            content: Text(
                              "Check your inbox for a password reset link.",
                            ),
                          ),
                        );
                      }).catchError((error) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Reset failed"),
                            content: Text(error.message ?? "Something went wrong."),
                          ),
                        );
                      });
                    }
                  },


                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolor.kblack,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Center(
                      child: Text(
                        AppString.kContinue,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Appcolor.kWhite,
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
