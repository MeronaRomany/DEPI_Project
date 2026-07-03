
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_color.dart';

class CustomCategoryItem extends StatelessWidget {
  const CustomCategoryItem({super.key,required this.text,this.isSelected =false});
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:50,
     width: 80,
     margin: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected?Appcolor.kred:Appcolor.kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Appcolor.kgrey),
      ),
      child: Center(
          child: Text(text,overflow:TextOverflow.ellipsis,maxLines: 1,
            style:
            TextStyle(
            color: Appcolor.kblack,fontWeight: FontWeight.bold),)),
    );
  }
}
List<CustomCategoryItem> categoryItems=[
  CustomCategoryItem(text: "ALL"),
  CustomCategoryItem(text: "States"),
  CustomCategoryItem(text: "Cities"),
  CustomCategoryItem(text: "Monument"),
  CustomCategoryItem(text: "restaurant"),

];