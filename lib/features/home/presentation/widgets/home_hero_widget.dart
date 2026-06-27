import 'package:flutter/material.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

import '../../../category/presentation/widgets/category_card_widget.dart';
import 'package:go_router/go_router.dart';

// hiển thị baner+ search+ category
class HomeHeroWidget extends StatefulWidget {
  const HomeHeroWidget({super.key});

  @override
  State<HomeHeroWidget> createState() => _HomeHeroWidgetState();
}

class _HomeHeroWidgetState extends State<HomeHeroWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.push('/search-tour?q=$query');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/banner.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),

          child: Container(
            padding: const EdgeInsets.all(20),
            // Lớp phủ tối
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  l10n.discover,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.amazingThings,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.heroSubtitle,
                  style: const TextStyle(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 15),
                // Search
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: l10n.whereToGo,
                      border: InputBorder.none,
                      icon: const Icon(
                        Icons.location_on_outlined,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: AppColors.primary),
                        onPressed: _onSearch,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const Positioned(
          left: 16,
          right: 16,
          bottom: -50,
          child: CategoryCardWidget(),
        ),
      ],
    );
  }
}