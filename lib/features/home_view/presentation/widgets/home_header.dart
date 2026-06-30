import 'package:depi_project/features/travel/presentation/controller/travel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constant/app_color.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final TravelController controller = Get.find<TravelController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore',
                style: TextStyle(
                  color: Appcolor.kgrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Obx(
                    () => Text(
                      controller.currentLocationLabel.value,
                      style: TextStyle(
                        color: Appcolor.kblack,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Appcolor.kblack),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Appcolor.kgrey.withAlpha(76)),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Appcolor.kblack),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}