import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/tour_card_widget.dart';

class SearchTourPage extends ConsumerWidget {
  final String query;

  const SearchTourPage({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsyncValue = ref.watch(searchToursProvider(query));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Kết quả: "$query"',
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: searchAsyncValue.when(
        data: (tours) {
          if (tours.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: AppColors.neutral),
                  SizedBox(height: 16),
                  Text(
                    'Không tìm thấy chuyến đi nào',
                    style: TextStyle(fontSize: 16, color: AppColors.neutral),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(searchToursProvider(query));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tours.length,
              itemBuilder: (context, index) {
                final tour = tours[index];
                final priceVnd = '${tour.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TourCardWidget(
                    imageUrl: tour.image,
                    priceUsd: '',
                    priceVnd: priceVnd,
                    title: tour.title,
                    description: 'Điểm đến: ${tour.location} - ${tour.duration}',
                    onTap: () {
                      context.push('/tour-detail', extra: tour);
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Lỗi tải dữ liệu:\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(searchToursProvider(query)),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
