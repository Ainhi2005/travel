import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/features/home/presentation/widgets/home_hero_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/home_slider_widget.dart';
import 'package:sesan_travel/core/widgets/section_header_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/tour_list_widget.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';

import '../../../tour/domain/repositories/tour_repository.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HomeHeroWidget(),
          const SizedBox(height: 52), // Space cho phần card đè lên ảnh
          const SectionHeaderWidget(title: 'Nổi bật'),
          const SizedBox(height: 12),
          const HomeSliderWidget(),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, child) {
              return SectionHeaderWidget(
                title: 'Tour Phổ Biến',
                actionText: 'Xem Tất cả',
                onActionTap: () {
                  ref.read(selectedTourTypeProvider.notifier).updateType(TourType.all);
                  context.push('/all-tour');
                },
              );
            }
          ),
          const SizedBox(height: 12),
          const TourListWidget(),
        ],
      ),
    );
  }
}
