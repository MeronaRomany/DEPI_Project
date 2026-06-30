import 'package:depi_project/features/travel/data/models/travel_item_entity.dart';
import 'package:flutter/material.dart';
import '../../../../core/constant/app_color.dart';

class SectionListWidget extends StatelessWidget {
  final String title;
  final List<TravelItemEntity> items;
  final VoidCallback? onSeeAll;

  const SectionListWidget({
    super.key,
    required this.title,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolor.kblack,
                ),
              ),
              TextButton(
                onPressed: onSeeAll ?? () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    color: Appcolor.kPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: item.imageUrl.isNotEmpty
                            ? Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: Appcolor.kgrey.withAlpha(20),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    _placeholder(),
                              )
                            : _placeholder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Appcolor.kblack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (item.rating != '0')
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: Appcolor.kAttractionYellow,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            item.rating,
                            style: TextStyle(
                              fontSize: 12,
                              color: Appcolor.kgrey,
                            ),
                          ),
                          if (item.numReviews != '0') ...[
                            const SizedBox(width: 4),
                            Text(
                              '(${item.numReviews})',
                              style: TextStyle(
                                fontSize: 11,
                                color: Appcolor.kgrey.withAlpha(150),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: Appcolor.kgrey.withAlpha(20),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
      ),
    );
  }
}
