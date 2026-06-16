import 'package:flutter/material.dart';
import 'package:sesan_travel/core/widgets/circular_back_button.dart';
import 'package:sesan_travel/core/widgets/primary_button.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_entity.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

class TourDetailPage extends StatelessWidget {
  final TourEntity tour;

  const TourDetailPage({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chi tiết tour', style: TextStyle(color: AppColors.neutral)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.neutral),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image with Back Button
                Stack(
                  children: [
                    Image.network(
                      tour.hinhAnh.isNotEmpty ? tour.hinhAnh.first : 'https://via.placeholder.com/400',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: AppColors.border,
                        child: const Center(child: Icon(Icons.image, size: 50, color: AppColors.textSecondary)),
                      ),
                    ),
                    const Positioned(
                      top: 16,
                      left: 16,
                      child: CircularBackButton(),
                    ),
                  ],
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        tour.tenTour,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.neutral,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Date and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Khởi hành: ${tour.thoiGianDi.xuatPhat.isNotEmpty ? tour.thoiGianDi.xuatPhat : 'Hàng ngày'}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Giá: ${tour.gia.nguoiLon} ${tour.gia.donViTienTe}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Chi tiết tour
                      const Text(
                        'Chi tiết tour',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tour.moTa.tongQuan,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.neutral,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Lịch trình
                      const Text(
                        'Lịch trình',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...tour.lichTrinh.map((item) {
                        if (item is Map) {
                          if (item.containsKey('thoi_gian')) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildScheduleItem('${item['thoi_gian']}: ', item['hoat_dong'] ?? ''),
                            );
                          } else if (item.containsKey('ngay')) {
                            // Xử lý nhiều ngày (demo đơn giản)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${item['ngay']}: ${item['tieu_de']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.neutral)),
                                const SizedBox(height: 4),
                                ...(item['chi_tiet'] as List? ?? []).map((ct) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
                                  child: _buildScheduleItem('${ct['thoi_gian']}: ', ct['hoat_dong'] ?? ''),
                                )).toList(),
                                const SizedBox(height: 8),
                              ],
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      }),
                      
                      const SizedBox(height: 100), // Space for floating button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Floating "Đặt ngay" Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: PrimaryButton(
              text: 'Đặt ngay',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String time, String detail) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.neutral,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: time,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: detail),
        ],
      ),
    );
  }
}
