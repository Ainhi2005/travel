import 'package:sesan_travel/features/tour/domain/entities/tour_request_entity.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_filter_entity.dart';

import '../entities/tour_entity.dart';
abstract class TourRepository {
  Future<List<TourEntity>>  getTours({
    TourFilterEntity? filter,
    String? sort,
    int page = 1,
    int limit = 3,
  });
  Future<List<TourEntity>> searchTours(String query);
  Future<List<TourEntity>> getFeaturedTours();
  Future<TourEntity> createTour(TourRequestEntity request);
  Future<TourEntity> updateTour(String id, TourRequestEntity request);
  Future<void> deleteTour(String id);
}
