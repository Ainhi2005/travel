import '../entities/tour_entity.dart';

enum TourType {
  daily,
  package,
  private,
  all
}

abstract class TourRepository {
  Future<List<TourEntity>> getTours(TourType type);
}
