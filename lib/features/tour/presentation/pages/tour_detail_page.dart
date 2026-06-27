import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_entity.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

import '../widgets/tour_image_header_widget.dart';
import '../widgets/tour_content_sheet_widget.dart';
import '../widgets/tour_sticky_bottom_bar_widget.dart';

class TourDetailPage extends ConsumerWidget {
  final TourEntity tour;

  const TourDetailPage({super.key, required this.tour});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceNum = tour.price.toDouble();
    final formattedPrice = '${priceNum.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} VND';
    final categoryName = tour.category?.name ?? 'Tour Hàng Ngày';
    
    final desc = (tour.description.isEmpty) 
      ? 'chưa có mô tả'
      : tour.description;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 1. Ảnh bìa (Nằm dưới cùng)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TourImageBackground(imageUrl: tour.image),
          ),

          // 2. Nội dung chi tiết cuộn (Bottom Sheet Style)
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4 - 24),
                  TourContentSheet(
                    tour: tour,
                    categoryName: categoryName,
                    formattedPrice: formattedPrice,
                    description: desc,
                  ),
                ],
              ),
            ),
          ),
          
          // 3. Nút Back và Bookmark (Nổi lên trên cùng, không bị đè bởi ScrollView)
          TourTopButtons(
            onEdit: () {
              context.push('/tour-form', extra: tour);
            },
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xác nhận xóa'),
                  content: const Text('Bạn có chắc chắn muốn xóa tour này không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                ref.read(toursProvider.notifier).deleteTour(tour.id);
                if (context.mounted) context.pop();
              }
            },
          ),
          
          // 4. Thanh đặt hàng cố định (Sticky Bottom Bar)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickyBottomBar(formattedPrice: formattedPrice),
          ),
        ],
      ),
    )
    );
  }
}
