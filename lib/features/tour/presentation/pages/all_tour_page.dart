import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/tour/presentation/pages/tour_page.dart';

class AllTourPage extends StatelessWidget {
  const AllTourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text(
          'Tất cả Tour',
          style: TextStyle(
            color: AppColors.neutral,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const TourPage(),
    );
  }
}
