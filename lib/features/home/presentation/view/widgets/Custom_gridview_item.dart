import 'package:flutter/material.dart';

import '../../../../../core/constant/app_color.dart';

class CustomGridviewItem extends StatelessWidget {
  const CustomGridviewItem({super.key,required this.image,required this.title});
 final String image;
   final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 250,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12)

          ),
          child: Image.asset(image,fit: BoxFit.cover,),
        ),
        Align(alignment: Alignment.bottomLeft,
            child: Text(title,style: TextStyle(color: Appcolor.kWhite,fontWeight: FontWeight.bold),)),
        Align(alignment: Alignment.topRight,
            child: Icon(Icons.favorite_border)),

      ]

    );
  }
}
