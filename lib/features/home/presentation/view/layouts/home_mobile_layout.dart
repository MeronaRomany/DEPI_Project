import 'package:depi_project/features/home/presentation/view/widgets/custum_catocary_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constant/app_color.dart';
import '../../../../../core/constant/app_string.dart';
import '../../../data/states_city_repo.dart';
import '../widgets/Custom_gridview_item.dart';

class HomeMobileLayout extends StatelessWidget {
  HomeMobileLayout({super.key});
  ValueNotifier<int> selectedIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Appcolor.kWhite,
        body: Column(
          spacing: 8,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/top-view-travel-kit-wooden-table.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
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
                style: TextStyle(fontSize: 12, color: Appcolor.kred),
                textInputAction: TextInputAction.search,
                cursorColor: Appcolor.kred,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Appcolor.kred),
                  labelText: AppString.khomeSearch,
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Appcolor.kred,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Appcolor.kgrey, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Appcolor.kred, width: 1.0),

                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Appcolor.kred, width: 1.0),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryItems.length,
                itemBuilder: (context, item) => ValueListenableBuilder(
                  valueListenable:selectedIndex ,
                  builder: (BuildContext context, value, Widget? child) =>
                      GestureDetector(
                          onTap: (){
                            selectedIndex.value=item;
                          },
                          child: CustomCategoryItem(
                            text: categoryItems[item].text,
                            isSelected: value == item,
                          ),
                      ),
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                // shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: StateCityRepo.data['states'].length,
                itemBuilder: (context, item) => CustomGridviewItem(
                  image: StateCityRepo.data['states'][item]['image'],
                  title: StateCityRepo.data['states'][item]['name'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
