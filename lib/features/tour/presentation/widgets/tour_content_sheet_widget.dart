import 'package:flutter/material.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_entity.dart';

class TourContentSheet extends StatelessWidget {
  final TourEntity tour;
  final String categoryName;
  final String formattedPrice;
  final String description;

  const TourContentSheet({
    super.key,
    required this.tour,
    required this.categoryName,
    required this.formattedPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề & Đánh giá
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  tour.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.neutral,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _RatingBadge(rating: tour.rating.toString()),
            ],
          ),
          const SizedBox(height: 12),
          
          // Thể loại (Category)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Giá tiền (per person)
          Text(
            formattedPrice,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          
          // Các thông số nhanh (Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TourInfoChip(icon: Icons.location_on_outlined, label: tour.location),
                const SizedBox(width: 12),
                _TourInfoChip(icon: Icons.access_time, label: tour.duration),
                const SizedBox(width: 12),
                _TourInfoChip(icon: Icons.people_alt_outlined, label: 'max ${tour.maxPeople}'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Tiêu đề Mô tả
          const Text(
            'Chi tiết tour',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral,
            ),
          ),
          const SizedBox(height: 12),
          
          // Nội dung Mô tả
          Text(
            description,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final String rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            rating,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TourInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TourInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}
