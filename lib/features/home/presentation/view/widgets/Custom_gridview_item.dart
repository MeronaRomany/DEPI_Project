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
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12)

          ),
        ),

        Align(

            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
              child: Text(title,style: TextStyle(color: Appcolor.kWhite,fontWeight: FontWeight.bold),),
            )),
        Align(alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
              child: Icon(Icons.favorite_border),
            )),

      ]

    );
  }
}
