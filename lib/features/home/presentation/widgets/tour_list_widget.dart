import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/core/widgets/custom_network_image.dart';

import '../../../tour/presentation/providers/tour_providers.dart';

class TourListScreen extends ConsumerWidget {
  const TourListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toursState = ref.watch(featuredToursProvider);

    return toursState.when(
      loading: () => const Center(child: CircularProgressIndicator()),// cấm vuốt
      error: (err, _) => Center(child: Text('Đã xảy ra lỗi: $err')),
      data: (tours) {
        if (tours.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Không có tour nổi bật nào.')),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: tours.length,
          itemBuilder: (context, index) {
            final tour = tours[index];
            
            final priceVnd = '${tour.price.toDouble().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ';
            final categoryName = tour.category?.name ?? 'TOUR NỔI BẬT';

            return Card(
              elevation: 4,
              shadowColor: AppColors.textSecondary.withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomNetworkImage(
                        imageUrl: tour.image,
                        width: 100,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              categoryName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Text(
                            tour.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Location
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded, color: AppColors.error, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  tour.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Price
                          Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: priceVnd,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' / người',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}