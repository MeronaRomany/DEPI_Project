import 'dart:async';
import 'package:flutter/material.dart';

// تأكدي من الاحتفاظ بسطر الـ Import الصحيح لصفحة الـ Sign In لديكِ واحذفي الآخر
import '../../../../../Auth/presentation/view/Sign in/layouts/sign_in_mobile_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // الانتظار لمدة 4 ثوانٍ ثم الانتقال مباشرة لصفحة الـ Sign In
    _timer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInMobileLayout(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إلغاء التايمر عند إغلاق الشاشة لمنع حدوث Memory Leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Screenshot 2026-06-27 233720.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}