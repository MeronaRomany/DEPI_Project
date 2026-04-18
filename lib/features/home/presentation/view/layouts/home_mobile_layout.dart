import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeMobileLayout extends StatelessWidget {
  const HomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop,t) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: Column(
          children: [
            Center(child: Text("home",)),

            Center(child: Text("home",style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
    );
  }
}
