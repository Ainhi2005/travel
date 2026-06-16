import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // 1. Icon khi KHÔNG được chọn
  Widget _buildIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Image.asset(assetPath, width: 24, height: 24),
    );
  }

  // 2. Icon KHI ĐƯỢC CHỌN (có box xám bao quanh)
  Widget _buildActiveIcon(String assetPath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.border, // Box màu xám nhạt
        borderRadius: BorderRadius.circular(16), // Bo góc cho box
      ),
      child: Image.asset(assetPath, width: 24, height: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      // 3. Vùng chứa tạo bo góc trên và bóng (shadow)
      decoration: BoxDecoration(
        color: AppColors.white, // Màu nền của Bottom Bar
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withOpacity(0.08), // Đổ bóng xám mờ
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -2), // Đẩy bóng lên phía trên (trục Y âm)
          ),
        ],
      ),
      // 4. ClipRRect cắt phần viền dư thừa của BottomNavigationBar theo góc bo
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          elevation: 0, // Quan trọng: Tắt shadow mặc định của Material
          selectedItemColor: AppColors.tertiary, // Màu text khi click
          unselectedItemColor: AppColors.textSecondary, // Màu text mặc định
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/house.png'),
              activeIcon: _buildActiveIcon('assets/images/house.png'), // Dùng icon có box xám
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/tour.png'),
              activeIcon: _buildActiveIcon('assets/images/tour.png'),
              label: l10n.tours,
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/images/profile.png'),
              activeIcon: _buildActiveIcon('assets/images/profile.png'),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
