import 'package:cached_network_image/cached_network_image.dart';
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              memCacheHeight: 400,
              memCacheWidth: 300,

              placeholder: (context, url) => Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),

              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ),

        Align(

            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,style: TextStyle(color: Appcolor.kWhite,fontWeight: FontWeight.bold),),
            )),
        Align(alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.favorite_border),
            )),

      ]

    );
  }
}
