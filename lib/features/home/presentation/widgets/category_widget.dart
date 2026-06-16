import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCategoryItem(
            icon: Icons.group,
            label: 'Nhóm hàng ngày',
            onTap: () {
              print('Nhóm hàng ngày');
            },
          ),
          _buildCategoryItem(
            icon: Icons.tour,
            label: 'Tour trọn gói',
            onTap: () {
              print('Tour trọn gói');
            },
          ),
          _buildCategoryItem(
            icon: Icons.people_alt,
            label: 'Tour riêng tư',
            onTap: () {
              print('Tour riêng tư');
            },
          ),
          
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
