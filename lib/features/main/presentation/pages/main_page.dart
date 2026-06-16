import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sesan_travel/features/home/presentation/pages/home_page.dart';
import 'package:sesan_travel/features/main/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:sesan_travel/features/tour/presentation/pages/tour_page.dart';
import 'package:sesan_travel/core/providers/locale_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 36),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SESAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary, // Màu xanh đen đậm
                    height: 1.1,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'TRAVEL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary, // Màu cam
                    height: 1.1,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Language Switcher
          GestureDetector(
            onTap: () {
              ref.read(localeProvider.notifier).toggleLocale();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.neutral.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, size: 16, color: AppColors.neutral),
                  const SizedBox(width: 6),
                  Text(
                    currentLocale.languageCode.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.neutral,
                  size: 28,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _selectedIndex == 0
          ? const HomePage()
          : _selectedIndex == 1
              ? const TourPage()
              : Center(
                  child: Text(l10n.tabUnderDevelopment(_selectedIndex)),
                ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
