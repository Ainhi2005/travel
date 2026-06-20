import '../entities/tour_entity.dart';
import '../repositories/tour_repository.dart';

class GetToursUseCase {
  final TourRepository repository;

  GetToursUseCase(this.repository);

 Future<List<TourEntity>> call(TourType type, {int page = 1, int limit = 3}) {
    // Truyền tiếp xuống repository
    return repository.getTours(type, page: page, limit: limit);
  }
}
