import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../tour/domain/repositories/tour_repository.dart';

class HomeHeroWidget extends ConsumerStatefulWidget {
  const HomeHeroWidget({super.key});

  @override
  ConsumerState<HomeHeroWidget> createState() => _HomeHeroWidgetState();
}

class _HomeHeroWidgetState extends ConsumerState<HomeHeroWidget> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            // Dark gradient overlay to make text readable
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.neutral.withOpacity(0.4),
                  AppColors.neutral.withOpacity(0.6),
                ],
              ),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'KHÁM PHÁ',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const Text(
                  'ĐIỀU TUYỆT VỜI',
                  style: TextStyle(
                    color: AppColors.primary, // Orange
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hành trình của bạn, ký ức của chúng tôi',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar
                GestureDetector(
                  onTap: () {
                    _searchFocusNode.requestFocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        const Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            focusNode: _searchFocusNode,
                            decoration: const InputDecoration(
                              hintText: 'Bạn muốn đi đâu?',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primary, // Orange
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: AppColors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Overlapping Category Card
        Positioned(
          left: 16,
          right: 16,
          bottom: -40,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryItem('assets/images/DAILYGROUPTOURS.png', 'Tour Hằng ngày', () {
                  ref.read(selectedTourTypeProvider.notifier).updateType(TourType.daily);
                  context.push('/all-tour');
                }),
                _buildCategoryItem('assets/images/PACKAGETOURS.png', 'Tour trọn gói', () {
                  ref.read(selectedTourTypeProvider.notifier).updateType(TourType.package);
                  context.push('/all-tour');
                }),
                _buildCategoryItem('assets/images/PRIVATETOURS.png', 'Tour riêng tư', () {
                   ref.read(selectedTourTypeProvider.notifier).updateType(TourType.private);
                   context.push('/all-tour');
                }),
                _buildCategoryItem('assets/images/more.png', 'Xem thêm', () {
                  ref.read(selectedTourTypeProvider.notifier).updateType(TourType.all);
                  context.push('/all-tour');
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String imagePath, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
