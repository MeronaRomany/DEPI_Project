import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileWidget;
  final Widget tabletWidget;
  final Widget websiteWidget;

  const ResponsiveLayout({super.key, required this.mobileWidget, required this.tabletWidget, required this.websiteWidget});


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraint){
      if(constraint.maxWidth >=1024){
        return  websiteWidget;
      }else if(constraint.maxWidth >=600){
        return tabletWidget;
      }else {
        return mobileWidget;
      }
    });
  }
}
