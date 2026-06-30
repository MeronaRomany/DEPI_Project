import 'package:flutter/material.dart';
import '../../../../core/constant/app_color.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'Attractions',
        'icon': Icons.account_balance_rounded,
        'color': Appcolor.kPrimary,
      },
      {'label': 'Hotels', 'icon': Icons.hotel_rounded, 'color': Colors.blue},
      {
        'label': 'Restaurants',
        'icon': Icons.restaurant_rounded,
        'color': Colors.green,
      },
      {
        'label': 'Historical',
        'icon': Icons.museum_rounded,
        'color': Colors.teal,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withAlpha(
                    30,
                  ), // خلفية خفيفة ملونة
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category['icon'],
                  color: category['color'],
                  size: 28,
                ),
              ),
              SizedBox(height: 8),
              Text(
                category['label'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Appcolor.kblack,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
