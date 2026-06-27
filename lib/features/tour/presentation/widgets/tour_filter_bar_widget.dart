import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/category/presentation/providers/category_provider.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/advanced_filter_bottom_sheet.dart';

class TourFilterBarWidget extends ConsumerWidget {
  const TourFilterBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(tourFilterProvider);
    final categories = ref.watch(categoryProvider).value ?? [];

    String categoryName = 'Tất cả danh mục';

    if (filter.categoryId != null) {
      try {
        categoryName =
            categories.firstWhere((e) => e.id == filter.categoryId).name;
      } catch (_) {}
    }

    final hasFilter =// kiểm tra có lọc k
        filter.minPrice != null ||
        filter.maxPrice != null ||
        (filter.location?.isNotEmpty ?? false) ||
        (filter.duration?.isNotEmpty ?? false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: PopupMenuButton<String>(
              offset: const Offset(0, 50),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                ref.read(tourFilterProvider.notifier).state = filter.copyWith(
                  categoryId: value == 'ALL' ? null : value,
                  clearCategory: value == 'ALL',
                );
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'ALL',
                  child: Text('Tất cả danh mục'),
                ),
                ...categories.map(
                  (e) => PopupMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
                ),
              ],
              child: OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.black),
                  disabledForegroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.tune, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        categoryName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AdvancedFilterBottomSheet(),
                );
              },
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 18,
                color: hasFilter
                    ? AppColors.primary
                    : AppColors.neutral,
              ),
              label: Text(
                'Bộ lọc',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: hasFilter
                      ? AppColors.primary
                      : AppColors.neutral,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: hasFilter
                    ? AppColors.primary
                    : AppColors.neutral,
                side: BorderSide(
                  color: hasFilter
                      ? AppColors.primary
                      : AppColors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}