import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/filter_chip_widget.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/tour_card_widget.dart';
import 'package:sesan_travel/core/widgets/custom_search_bar.dart';
import 'package:sesan_travel/features/tour/domain/repositories/tour_repository.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

class TourPage extends ConsumerWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedTourTypeProvider);
    final toursAsyncValue = ref.watch(toursProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Search Bar
        const CustomSearchBar(hintText: 'Tìm kiếm tour du lịch...'),
        const SizedBox(height: 16),
        // Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChipWidget(
                label: 'Tất cả',
                isActive: selectedType == TourType.all,
                onTap: () => ref.read(selectedTourTypeProvider.notifier).updateType(TourType.all),
              ),
              FilterChipWidget(
                label: 'Tour Hàng ngày',
                isActive: selectedType == TourType.daily,
                onTap: () => ref.read(selectedTourTypeProvider.notifier).updateType(TourType.daily),
              ),
              FilterChipWidget(
                label: 'Tour Trọn Gói',
                isActive: selectedType == TourType.package,
                onTap: () => ref.read(selectedTourTypeProvider.notifier).updateType(TourType.package),
              ),
              FilterChipWidget(
                label: 'Tour Riêng Tư',
                isActive: selectedType == TourType.private,
                onTap: () => ref.read(selectedTourTypeProvider.notifier).updateType(TourType.private),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Khám phá',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // List of Tours
        Expanded(
          child: toursAsyncValue.when(
            data: (tours) {
              if (tours.isEmpty) {
                return const Center(child: Text('Không có dữ liệu tour.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: tours.length,
                itemBuilder: (context, index) {
                  final tour = tours[index];
                  // Lấy hình ảnh đầu tiên hoặc ảnh mặc định
                  final imageUrl = tour.hinhAnh.isNotEmpty 
                      ? tour.hinhAnh.first 
                      : 'https://via.placeholder.com/150';

                  // Format tiền tệ đơn giản (có thể nâng cấp thư viện intl sau)
                  final priceVnd = '${tour.gia.nguoiLon.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]}.')} ${tour.gia.donViTienTe}';
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TourCardWidget(
                      imageUrl: imageUrl,
                      priceUsd: '', // Mock data không có trường usd, tạm để trống
                      priceVnd: priceVnd,
                      title: tour.tenTour,
                      description: tour.moTa.tongQuan,
                      onTap: () {
                        context.push('/tour-detail', extra: tour);
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (error, stack) => Center(child: Text('Đã có lỗi xảy ra: $error')),
          ),
        ),
      ],
    );
  }
}
