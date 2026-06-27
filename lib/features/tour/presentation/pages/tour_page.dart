import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/tour_card_widget.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/tour_filter_bar_widget.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

class TourPage extends ConsumerWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toursAsyncValue = ref.watch(toursProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Lọc Danh Mục và Sắp xếp
        const TourFilterBarWidget(),
        
        const SizedBox(height: 24),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.explore,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/tour-form');
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Thêm chuyến đi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // List of Tours
        Expanded(
          child: toursAsyncValue.when(
            data: (tours) {
              if (tours.isEmpty) {
                return Center(child: Text(l10n.noToursFound));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                itemCount: tours.length,
                itemBuilder: (context, index) {
                  final tour = tours[index];
                  // Lấy hình ảnh đầu tiên hoặc ảnh mặc định
                  final imageUrl = tour.image;

                  // Format tiền tệ đơn giản
                  final priceNum = tour.price;
                  final priceVnd =
                      '${priceNum.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TourCardWidget(
                      imageUrl: imageUrl,
                      priceUsd: '',
                      priceVnd: priceVnd,
                      title: tour.title,
                      description:
                          'Điểm đến: ${tour.location} - ${tour.duration}',
                      onTap: () {
                         context.push('/tour-detail', extra: tour);
                      },
                      onEdit: () {
                        context.push('/tour-form', extra: tour);
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: const Text(
                              'Bạn có chắc chắn muốn xóa tour này không?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Xóa',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          ref.read(toursProvider.notifier).deleteTour(tour.id);
                        }
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (error, stack) =>
                Center(child: Text(l10n.errorOccurred(error.toString()))),
          ),
        ),
      ],
    );
  }
}
