import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/l10n/app_localizations.dart';
import 'package:sesan_travel/core/widgets/primary_button.dart';
import 'package:sesan_travel/core/widgets/section_header_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/home_hero_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/home_slider_widget.dart';
import 'package:sesan_travel/features/home/presentation/widgets/tour_list_widget.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';
import 'package:sesan_travel/main.dart';

import '../../../tour/domain/repositories/tour_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(toursProvider.notifier).fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => ref.read(toursProvider.notifier).refresh(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics:
            const AlwaysScrollableScrollPhysics(), // Quan trọng để RefreshIndicator hoạt động được
        child: Column(
          children: [
            const HomeHeroWidget(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PrimaryButton(
                text: 'Thông đơn hàng thành công',
                onPressed: () async {
                  await localNotificationService.showNotification(
                    title: 'Thông báo đặt tour thành công',
                    body: 'Chúc mừng bạn đã đặt tour thành công!',
                  );
                },
              ),
            ),

            const SizedBox(height: 36), // Space cho phần card đè lên ảnh
            SectionHeaderWidget(title: l10n.featured),
            const SizedBox(height: 12),
            const HomeSliderWidget(),
            const SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                return SectionHeaderWidget(
                  title: l10n.popularTours,
                  actionText: l10n.viewAll,
                  onActionTap: () {
                    ref
                        .read(selectedTourTypeProvider.notifier)
                        .updateType(TourType.all);
                    context.push('/all-tour');
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            const TourListScreen(),
          ],
        ),
      ),
    );
  }
}
