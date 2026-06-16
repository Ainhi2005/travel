import '../entities/tour_entity.dart';
import '../repositories/tour_repository.dart';

class GetToursUseCase {
  final TourRepository repository;

  GetToursUseCase(this.repository);

  Future<List<TourEntity>> call(TourType type) {
    return repository.getTours(type);
  }
}
