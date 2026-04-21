import 'package:depi_project/features/home/presentation/view/widgets/custum_catocary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../../../core/constant/app_string.dart';


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
        backgroundColor: Appcolor.kWhite,
        body: Column(
          spacing: 8,
          children: [
            Container(
                width: double.infinity,height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight:Radius.circular(12) ),
                ),
                child: Image.asset("assets/images/top-view-travel-kit-wooden-table.jpg",
                    fit: BoxFit.cover,
                )

            ),
            TextFormField(
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
                labelText: AppString.khomeSearch,

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
                  borderSide: BorderSide(color: Appcolor.kred, width: 2.0),
                ),
              ),
            ),
            ListView.builder(
                itemCount:categoryItems.length ,
                itemBuilder: (context, item)=>categoryItems[item]),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context,item)=>Container()
      ),

          ],
        ),
      ),
    );
  }
}
