import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../tour/presentation/providers/tour_providers.dart';

class TourListScreen extends ConsumerWidget {
  const TourListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toursState = ref.watch(toursProvider);

    return toursState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Đã xảy ra lỗi: $err')),
      data: (tours) {
        if (tours.isEmpty) {
          return const SizedBox(
            height: 300,
            child: Center(child: Text('Không có tour nào.')),
          );
        }

        final hasMore = ref.watch(toursProvider.notifier).hasMore;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: tours.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == tours.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final tour = tours[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(tour.tenTour ?? 'Chưa có tên'),
                subtitle: Text('Giá: ${tour.gia.nguoiLon}'),
              ),
            );
          },
        );
      },
    );
  }
}
