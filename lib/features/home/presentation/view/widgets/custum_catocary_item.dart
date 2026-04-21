
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_color.dart';

class CustomCategoryItem extends StatelessWidget {
  CustomCategoryItem({super.key,required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Appcolor.kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Appcolor.kgrey),
      ),
      child: Text(text,style: TextStyle(color: Appcolor.kblack,fontWeight: FontWeight.bold),),
    );
  }
}
List<CustomCategoryItem> categoryItems=[
  CustomCategoryItem(text: "ALL"),
  CustomCategoryItem(text: "States"),
  CustomCategoryItem(text: "Monument"),
  CustomCategoryItem(text: "restaurant"),

];