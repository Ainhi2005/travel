import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/tour/presentation/pages/tour_detail_page.dart';
import '../../features/tour/domain/entities/tour_entity.dart';
import '../../features/tour/presentation/pages/tour_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/tour-detail',
      builder: (context, state) {
        final tour = state.extra as TourEntity;
        return TourDetailPage(tour: tour);
      },
    ),
    GoRoute(
      path: '/all-tour',
      builder: (context, state) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.neutral),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Tất cả Tour',
            style: TextStyle(color: AppColors.neutral, fontWeight: FontWeight.bold),
          ),
        ),
        body: const TourPage(),
      ),
    ),
  ],
);
