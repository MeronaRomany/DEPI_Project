import 'package:depi_project/features/travel/presentation/cubit/travel_cubit.dart';
import 'package:depi_project/features/travel/presentation/cubit/travel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/app_color.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'label': 'All',
        'icon': Icons.apps_rounded,
        'color': Appcolor.kPrimary,
        'category': TravelCategory.all,
      },
      {
        'label': 'Attractions',
        'icon': Icons.account_balance_rounded,
        'color': Appcolor.kAttractionYellow,
        'category': TravelCategory.attractions,
      },
      {
        'label': 'Hotels',
        'icon': Icons.hotel_rounded,
        'color': Colors.blue,
        'category': TravelCategory.hotels,
      },
      {
        'label': 'Restaurants',
        'icon': Icons.restaurant_rounded,
        'color': Colors.green,
        'category': TravelCategory.restaurants,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<TravelCubit, TravelState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.map((category) {
              final isSelected = state.selectedCategory == category['category'];
              final color = category['color'] as Color;

              return GestureDetector(
                onTap: () {
                  context.read<TravelCubit>().selectCategory(category['category']);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withAlpha(30),
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withAlpha(80),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        category['icon'],
                        color: isSelected ? Colors.white : color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['label'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? color : Appcolor.kblack,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
