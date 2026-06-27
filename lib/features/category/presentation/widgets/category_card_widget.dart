import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import '../providers/category_provider.dart';

class CategoryCardWidget extends ConsumerWidget {
  const CategoryCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: categoriesAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        error: (error, stack) {
          return Center(
            child: Text("Lỗi: $error"),
          );
        },

        data: (categories) {
          List<Widget> items = [];
          for (var category in categories) {
            items.add(
              Expanded(
                //GestureDetector là widget giúp lắng nghe các sự kiện cảm ứng như onTap,...
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(selectedTourCategoryProvider.notifier)
                        .state = category.id;// gán state của provider thành id của danh mục
                    context.push("/all-tour");
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        category.image,
                        width: 32,
                        height: 32,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          items.add(
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(selectedTourCategoryProvider.notifier)
                      .state = null;

                  context.push("/all-tour");
                },
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/more.png",
                      width: 32,
                      height: 32,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      l10n.seeMore,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
          return Row(
            children: items,
          );
        },
      ),
    );
  }
}