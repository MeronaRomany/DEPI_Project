import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/routing/routes.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isVerified = false;
  bool canResend = true;

  @override
  void initState() {
    super.initState();
    checkEmailVerified();
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      isVerified = user?.emailVerified ?? false;
    });
    if (!isVerified) {
      Future.delayed(const Duration(seconds: 3), checkEmailVerified);
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() => canResend = false);
        await Future.delayed(const Duration(seconds: 30));
        setState(() => canResend = true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Email")),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 50,bottom: 8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                isVerified
                    ? "✅ Your email is verified!"
                    : "Please check your email and verify your account.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              if (!isVerified)
                ElevatedButton(
                  onPressed: canResend ? resendVerificationEmail : null,
                  child: const Text("Resend Verification Email"),
                ),
              const SizedBox(height: 10),
              if (isVerified)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.homePage);
                  },
                  child: const Text("Continue to Home"),
                ),
            ],
          ),
        ),
      ),
    );
  }

}