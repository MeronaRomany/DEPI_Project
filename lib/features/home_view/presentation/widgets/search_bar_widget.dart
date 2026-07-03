import 'package:depi_project/features/travel/presentation/controller/travel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_color.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TravelController controller = Get.find<TravelController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => controller.searchLocation(value),
        decoration: InputDecoration(
          hintText: 'Search for a city (e.g. Paris)...',
          hintStyle: TextStyle(color: Appcolor.kgrey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Appcolor.kgrey),
          suffixIcon: Obx(
            () => controller.isSearchingLocation.value
                ? const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Icon(Icons.tune, color: Appcolor.kgrey),
          ),
          filled: true,
          fillColor: Appcolor.kWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Appcolor.kgrey.withAlpha(40)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Appcolor.kPrimary),
          ),
        ),
      ),
    );
  }
}