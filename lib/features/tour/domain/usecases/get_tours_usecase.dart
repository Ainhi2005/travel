import '../entities/tour_entity.dart';
import '../entities/tour_filter_entity.dart';
import '../repositories/tour_repository.dart';

class GetToursUseCase {
  final TourRepository repository;

  GetToursUseCase(this.repository);

  Future<List<TourEntity>> call({
    TourFilterEntity? filter,
    String? sort,
    int page = 1,
    int limit = 3,
  }) async {
    return repository.getTours(
      filter: filter,
      sort: sort,
      page: page,
      limit: limit,
    );
  }
}
