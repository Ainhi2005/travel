import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';

import '../../../../core/theme/app_colors.dart' show AppColors;

class TourListWidget extends ConsumerWidget {
  const TourListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toursAsyncValue = ref.watch(toursProvider);

    return toursAsyncValue.when(
      data: (tours) {
        if (tours.isEmpty) {
          return const Center(child: Text('Không có tour phổ biến.'));
        }

        // Chỉ hiện 3 tour đầu tiên cho gọn
        final displayTours = tours.take(3).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: displayTours.length,
          itemBuilder: (context, index) {
            final tour = displayTours[index];
            final imageUrl = tour.hinhAnh.isNotEmpty
                ? tour.hinhAnh.first
                : 'https://via.placeholder.com/150';

            return GestureDetector(
              onTap: () => context.push('/tour-detail', extra: tour),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: AppColors.border,
                          child: const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
                    ),
                    // Nội dung
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Giá
                            Row(
                              children: [
                                Text(
                                  'Giá từ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  ' ${_formatPrice(tour.gia.nguoiLon.toInt())} ${tour.gia.donViTienTe}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Title
                            Text(
                              tour.tenTour,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Description
                            Text(
                              tour.moTa.tongQuan,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, st) => Center(child: Text('Lỗi tải tour phổ biến: $e')),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}
