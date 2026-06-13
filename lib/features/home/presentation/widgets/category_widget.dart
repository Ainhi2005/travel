import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final int user = 1;
    final int admin = 2;
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
          if (user == 5) ...[
            _buildCategoryItem(
              icon: Icons.directions_car,
              label: 'Admin',
              onTap: () {
                print('Admin');
              },
            ),
          ] else ...[
            _buildCategoryItem(
              icon: Icons.directions_car,
              label: 'Thuê xe',
              onTap: () {
                print('Thuê xe');
              },
            ),
          ],
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
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
